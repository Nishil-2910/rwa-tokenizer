const express = require("express");
const router = express.Router();
const lendingController = require("../controllers/lendingController");

router.post("/deposit", lendingController.depositNFTForLoan);
router.post("/repay", lendingController.repayLoan);
router.post("/set-value", lendingController.setNFTValue);
router.post("/liquidate", lendingController.liquidate);

module.exports = router;
