const fractionalService = require("../services/fractionalService");

// Mint fractional tokens
exports.mintFraction = async (req, res) => {
    try {
        const { to, amount } = req.body;
        const tx = await fractionalService.mintFraction(to, amount);
        res.json({ success: true, tx });
    } catch (err) {
        res.status(500).json({ success: false, error: err.message });
    }
};

// Burn fractional tokens (by owner)
exports.burnFraction = async (req, res) => {
    try {
        const { from, amount } = req.body;
        const tx = await fractionalService.burnFraction(from, amount);
        res.json({ success: true, tx });
    } catch (err) {
        res.status(500).json({ success: false, error: err.message });
    }
};

// Burn own tokens
exports.burnOwnTokens = async (req, res) => {
    try {
        const { amount } = req.body;
        const tx = await fractionalService.burnOwnTokens(amount);
        res.json({ success: true, tx });
    } catch (err) {
        res.status(500).json({ success: false, error: err.message });
    }
};

// Get token info
exports.getTokenInfo = async (req, res) => {
    try {
        const info = await fractionalService.getTokenInfo();
        res.json({ success: true, info });
    } catch (err) {
        res.status(500).json({ success: false, error: err.message });
    }
};
