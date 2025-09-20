const marketplaceService = require("../services/marketplaceService");

module.exports = {
  async listNFT(req, res) {
    try {
      const { tokenId, price } = req.body;
      const receipt = await marketplaceService.listNFT(tokenId, price);
      res.json({ success: true, receipt });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  },

  async listFraction(req, res) {
    try {
      const { tokenId, fractionalToken, amount, pricePerToken } = req.body;
      const receipt = await marketplaceService.listFraction(
        tokenId,
        fractionalToken,
        amount,
        pricePerToken
      );
      res.json({ success: true, receipt });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  },

  async buyNFT(req, res) {
    try {
      const { tokenId, value } = req.body;
      const receipt = await marketplaceService.buyNFT(tokenId, value);
      res.json({ success: true, receipt });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  },

  async buyFraction(req, res) {
    try {
      const { tokenId, amount, value } = req.body;
      const receipt = await marketplaceService.buyFraction(tokenId, amount, value);
      res.json({ success: true, receipt });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  },

  async cancelNFTListing(req, res) {
    try {
      const { tokenId } = req.body;
      const receipt = await marketplaceService.cancelNFTListing(tokenId);
      res.json({ success: true, receipt });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  },

  async cancelFractionalListing(req, res) {
    try {
      const { tokenId } = req.body;
      const receipt = await marketplaceService.cancelFractionalListing(tokenId);
      res.json({ success: true, receipt });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  },
};
