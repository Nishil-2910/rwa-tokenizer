exports.toEther = (wei) => (Number(wei) / 1e18).toFixed(4);
exports.toWei = (eth) => ethers.parseEther(eth.toString());
