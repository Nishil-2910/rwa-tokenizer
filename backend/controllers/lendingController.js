const lendingService = require("../services/lendingService");

module.exports = {
  async depositNFTForLoan(req, res) {
    try {
      const { tokenId, loanAmount } = req.body;
      const receipt = await lendingService.depositNFTForLoan(tokenId, loanAmount);
      res.json({ success: true, receipt });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  },

  async repayLoan(req, res) {
    try {
      const { tokenId, repayAmount } = req.body;
      const receipt = await lendingService.repayLoan(tokenId, repayAmount);
      res.json({ success: true, receipt });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  },

  async liquidate(req, res) {
    try {
      const { tokenId } = req.body;
      const receipt = await lendingService.liquidate(tokenId);
      res.json({ success: true, receipt });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  },

  async viewLoan(req, res) {
    try {
      const { tokenId } = req.query;
      const loan = await lendingService.viewLoan(tokenId);
      res.json({ success: true, loan });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  },

  async fundContract(req, res) {
    try {
      const { amount } = req.body;
      const receipt = await lendingService.fundContract(amount);
      res.json({ success: true, receipt });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  },

  // Add this function to your lendingController.js
async setNFTValue(req, res) {
  try {
    const { tokenId, value } = req.body;
    // You'll need to add this function to your lendingService.js too
    const receipt = await lendingService.setNFTValue(tokenId, value);
    res.json({ success: true, receipt });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
},

  async withdrawUSDC(req, res) {
    try {
      const { amount } = req.body;
      const receipt = await lendingService.withdrawUSDC(amount);
      res.json({ success: true, receipt });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  },
};
