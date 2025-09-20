const express = require("express");
const router = express.Router();
const fractionalController = require("../controllers/fractionalController");

// Mint fractional tokens
router.post("/mint", fractionalController.mintFraction);

// Burn fractional tokens (by owner)
router.post("/burn", fractionalController.burnFraction);

// Optional: Burn own tokens
router.post("/burn-self", fractionalController.burnOwnTokens);

// View token info
router.get("/info", fractionalController.getTokenInfo);

module.exports = router;
