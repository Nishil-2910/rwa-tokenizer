const express = require("express");
const router = express.Router();
const marketplaceController = require("../controllers/marketplaceController");

// NFT Listings
router.post("/list", marketplaceController.listNFT);
router.post("/buy", marketplaceController.buyNFT);
router.post("/cancel", marketplaceController.cancelNFTListing);

// Fractional Tokens Listings
router.post("/list-fraction", marketplaceController.listFraction);
router.post("/buy-fraction", marketplaceController.buyFraction);
router.post("/cancel-fraction", marketplaceController.cancelFractionalListing);

module.exports = router;
