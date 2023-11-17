const express = require('express');
const app = express();
const port = process.env.PORT || 3030;

// Require the database connection if you have one
// const dbConnection = require('./config/db');
// dbConnection(); // Initialize database connection

// Middlewares
app.use(express.json()); // for parsing application/json

// Homart Print Routes for API v1
const homartPrintRoutes = require('./api/v1/routes/homartPrintRoute');

// Using the routes
app.use('/api/v1', homartPrintRoutes);

// Handle 404 - Not Found
app.use((req, res, next) => {
    res.status(404).send("HTTP Code: 404!");
});

// Error Handling Middleware
app.use((error, req, res, next) => {
    console.error(error.stack);
    res.status(500).send('Error code 500!');
});

// Starting the server
app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
