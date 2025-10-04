const express = require("express");
const app = express();
require("dotenv").config();

const nftRoutes = require("./routes/nftRoutes");
const marketplaceRoutes = require("./routes/marketplaceRoutes");
const lendingRoutes = require("./routes/lendingRoutes");
const fractionalRoutes = require("./routes/fractionalRoutes"); // <--- new

app.use(express.json());

// Routes
app.use("/api/nft", nftRoutes);
app.use("/api/marketplace", marketplaceRoutes);
app.use("/api/lending", lendingRoutes);
app.use("/api/fractional", fractionalRoutes); // <--- new

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Backend running on port ${PORT}`));

