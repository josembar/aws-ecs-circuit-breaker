const express = require('express');
const bodyParser = require('body-parser');
const winston = require("winston");
const port = process.env.PORT || 3000

const app = express();

// logger configuration
const logger = winston.createLogger({
    // Log only if level is less than (meaning more severe) or equal to this
    level: "info",
    // Use timestamp and printf to create a standard log format
    format: winston.format.combine(
      winston.format.timestamp(),
      winston.format.printf(
        (info) => `${info.timestamp} ${info.level}: ${info.message}`
      )
    ),
    // Log to the console
    transports: [
      new winston.transports.Console()
    ],
});

// app configuration
app.set('json spaces', 2)

// middleware
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// logging configuration for app
app.use((req, res, next) => {
    // Log an info message for each incoming request
    logger.info(`Received a ${req.method} request for ${req.url}`);
    next();
});

// routes
app.use(require('./routes/appRoutes'));

// server start
app.listen(port, () => {
  logger.log("info", `Server listening on port ${port}`);
});