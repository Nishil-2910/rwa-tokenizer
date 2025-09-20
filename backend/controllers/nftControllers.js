const nftService = require("../services/nftService");

exports.mintAsset = async (req, res) => {
  try {
    const result = await nftService.mintAsset(req.body.to, req.body.metadataURI);
    res.json({ success: true, txHash: result });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

exports.getAssetDetails = async (req, res) => {
  try {
    const result = await nftService.getAssetDetails(req.params.tokenId);
    res.json({ success: true, data: result });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};
