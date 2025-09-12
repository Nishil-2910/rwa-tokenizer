import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-verify";
import * as dotenv from "dotenv";

dotenv.config();

const config: any = { // 👈 changed from HardhatUserConfig
  solidity: "0.8.24",
  networks: {
    fuji: {
      type: "http",
      url: process.env.FUJI_RPC_URL || "",
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      chainId: 43113,
    },
  },
  etherscan: {
    apiKey: {
      avalancheFujiTestnet: "YOUR_SNOWTRACE_API_KEY",
    },
  },
};

export default config;
