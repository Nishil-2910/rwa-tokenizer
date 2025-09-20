const { rwaNFTContract } = require("../config");

exports.mintAsset = async (to, metadataURI) => {
  const tx = await rwaNFTContract.mintAsset(to, metadataURI);
  await tx.wait();
  return tx.hash;
};

exports.getAssetDetails = async (tokenId) => {
  const [uri, fractionalToken] = await rwaNFTContract.getAssetDetails(tokenId);
  return { tokenId, metadataURI: uri, fractionalToken };
};
