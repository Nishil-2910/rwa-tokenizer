const express = require("express");
const router = express.Router();
const nftController = require("../controllers/nftController");

router.post("/mint", nftController.mintAsset);
router.get("/:tokenId", nftController.getAssetDetails);

module.exports = router;
