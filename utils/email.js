const nodemailer = require('nodemailer');
require('dotenv').config();

module.exports.transporter = nodemailer.createTransport({
  service: process.env.EMAIL_SERVICE, // You can use other services like Yahoo, Outlook, etc., or provide SMTP details
  port: 465,
  secure: true,
  logger: true,
  debug: true,
  secureConnection: false,
  tls: {
    rejectUnauthorized: true,
  },
  auth: {
    user: process.env.EMAIL_USER, // Your email address
    pass: process.env.EMAIL_PASS    // Your email password or app-specific password
  }
});