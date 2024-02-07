const express = require("express");
const cors = require("cors");
const app = express();
const port = process.env.PORT || 3030;

// Require the database connection if you have one
// const dbConnection = require('./config/db');
// dbConnection(); // Initialize database connection

// Middlewares
// Increase the limit for JSON data
app.use(express.json({ limit: '50mb' })); // for parsing application/json

// Increase the limit for URL-encoded data
app.use(express.urlencoded({ limit: '50mb', extended: true }));

// Cors
app.use(cors());

// Routes for API v1
const homartPrintRoutes = require("./api/v1/routes/homartPrintRoute");
const homartBrotherPrinterRoute = require("./api/v1/routes/homartBrotherPrinterRoute");
const getRdsSessionStatus = require("./api/v1/routes/homartRdsSessionRoute");
const replicationHealth = require("./api/v1/routes/replicationHealthRoute");
const iGuard = require("./api/v1/routes/homartiGuardRoute")
const homartGetHypervVmDetailRoute = require("./api/v1/routes/homartGetHypervVmDetailRoute")
const dellServerOpenManageRoute = require("./api/v1/routes/dellServerOpenManageRoute")

// Using the routes
app.use("/api/v1", homartPrintRoutes);
app.use("/api/v1", homartBrotherPrinterRoute);
app.use("/api/v1", getRdsSessionStatus);
app.use("/api/v1", replicationHealth);
app.use("/api/v1", iGuard);
app.use("/api/v1", homartGetHypervVmDetailRoute);
app.use("/api/v1", dellServerOpenManageRoute);

// Handle 404 - Not Found
app.use((req, res, next) => {
  res.status(404).send("HTTP Code: 404!");
});

// Error Handling Middleware
app.use((error, req, res, next) => {
  console.error(error.stack);
  res.status(500).send("Error code 500!");
});

// Starting the server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
