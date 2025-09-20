const express = require("express");
const router = express.Router();
const marketplaceController = require("../controllers/marketplaceController");

router.post("/list", marketplaceController.listNFT);
router.post("/list-fraction", marketplaceController.listFraction);
router.post("/buy", marketplaceController.buyNFT);
router.post("/buy-fraction", marketplaceController.buyFraction);
router.post("/cancel", marketplaceController.cancelListing);

module.exports = router;
