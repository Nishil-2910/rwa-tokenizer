// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./RWANFT.sol";

contract RWALending is Ownable, IERC721Receiver, ReentrancyGuard {
    RWANFT public nftContract;
    IERC20 public usdcToken;

    uint256 public collateralizationRatio = 150; // 150% collateral required

    struct Loan {
        address borrower;
        uint256 loanAmount; // in USDC
        uint256 nftTokenId;
        bool active;
        uint256 timestamp; // loan creation time
    }

    mapping(uint256 => Loan) public loans; // tokenId => Loan
    mapping(uint256 => uint256) public nftValues; // tokenId => NFT value in USDC

    // Events
    event NFTDeposited(address indexed user, uint256 tokenId, uint256 loanAmount);
    event LoanRepaid(address indexed user, uint256 tokenId, uint256 amount);
    event NFTLiquidated(address indexed user, uint256 tokenId);
    event NFTValueSet(uint256 tokenId, uint256 value);

    constructor(address _nftContract, address _usdcToken) Ownable(msg.sender) {
        nftContract = RWANFT(_nftContract);
        usdcToken = IERC20(_usdcToken);
    }

    // Receive NFT safely
    function onERC721Received(address, address, uint256, bytes calldata) external pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    // Set NFT value manually
    function setNFTValue(uint256 tokenId, uint256 value) external onlyOwner {
        nftValues[tokenId] = value;
        emit NFTValueSet(tokenId, value);
    }

    // Deposit NFT and borrow USDC
    function depositNFTForLoan(uint256 tokenId, uint256 loanAmount) external nonReentrant {
        require(nftContract.ownerOf(tokenId) == msg.sender, "Not NFT owner");
        require(!loans[tokenId].active, "Loan already active");
        require(loanAmount > 0, "Loan amount must be > 0");
        require(nftValues[tokenId] > 0, "NFT value not set");

        uint256 maxLoan = (nftValues[tokenId] * 100) / collateralizationRatio;
        require(loanAmount <= maxLoan, "Loan exceeds allowed collateral");
        require(usdcToken.balanceOf(address(this)) >= loanAmount, "Insufficient USDC in contract");

        nftContract.safeTransferFrom(msg.sender, address(this), tokenId);

        loans[tokenId] = Loan({
            borrower: msg.sender,
            loanAmount: loanAmount,
            nftTokenId: tokenId,
            active: true,
            timestamp: block.timestamp
        });

        require(usdcToken.transfer(msg.sender, loanAmount), "USDC transfer failed");
        emit NFTDeposited(msg.sender, tokenId, loanAmount);
    }

    // Repay loan
    function repayLoan(uint256 tokenId, uint256 repayAmount) external nonReentrant {
        Loan storage loan = loans[tokenId];
        require(loan.active, "No active loan");
        require(msg.sender == loan.borrower, "Not borrower");
        require(repayAmount > 0, "Repay amount must be > 0");

        require(usdcToken.transferFrom(msg.sender, address(this), repayAmount), "USDC transfer failed");

        if (repayAmount >= loan.loanAmount) {
            uint256 excess = repayAmount - loan.loanAmount;
            if (excess > 0) {
                require(usdcToken.transfer(msg.sender, excess), "Excess refund failed");
            }
            loan.active = false;
            loan.loanAmount = 0;
            nftContract.safeTransferFrom(address(this), msg.sender, tokenId);
        } else {
            loan.loanAmount -= repayAmount;
        }

        emit LoanRepaid(msg.sender, tokenId, repayAmount);
    }

    // Liquidate NFT
    function liquidate(uint256 tokenId) external onlyOwner nonReentrant {
        Loan storage loan = loans[tokenId];
        require(loan.active, "No active loan");
        loan.active = false;
        emit NFTLiquidated(loan.borrower, tokenId);
    }

    // Admin functions
    function setCollateralizationRatio(uint256 ratio) external onlyOwner {
        require(ratio > 100, "Ratio must be > 100%");
        collateralizationRatio = ratio;
    }

    function fundContract(uint256 amount) external onlyOwner {
        require(usdcToken.transferFrom(msg.sender, address(this), amount), "Funding failed");
    }

    function withdrawUSDC(uint256 amount) external onlyOwner {
        require(usdcToken.balanceOf(address(this)) >= amount, "Insufficient balance");
        require(usdcToken.transfer(msg.sender, amount), "Withdrawal failed");
    }

    function emergencyRecoverNFT(uint256 tokenId, address to) external onlyOwner {
        require(!loans[tokenId].active, "Loan is active");
        nftContract.safeTransferFrom(address(this), to, tokenId);
    }

    function viewLoan(uint256 tokenId) external view returns (Loan memory) {
        return loans[tokenId];
    }

    function getContractBalance() external view returns (uint256) {
        return usdcToken.balanceOf(address(this));
    }
}
