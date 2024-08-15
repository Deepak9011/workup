// import { fbApp } from "./firebase.js";
// const cred = require('./stor-e-by-ecell-firebase-adminsdk-i1qnv-c0a67881c5')
const express = require('express');
const connectDB = require('./db');
const Product = require('./models/product')
const productRoutes = require('./routes/productRoutes');
const userRoutes = require('./routes/userRoutes');
const orderRoutes = require('./routes/orderRoutes');
const cors = require('cors');
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 1000 // limit each IP to 100 requests per windowMs
});

var app = express()

// app.use(limiter);

app.use(cors());

app.use(express.json());

connectDB();

app.use(express.urlencoded({ extended: true }));

app.set('trust proxy', 1);

// app.use((err, req, res, next) => {
//   if (err instanceof RateLimitError) {
//     res.status(429).json({ error: 'Rate limit exceeded' });
//   } else {
//     next();
//   }
// });

app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*'); // Allow requests from any origin
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS'); // Allow specified methods
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization'); // Allow specified headers
  res.setHeader('Access-Control-Allow-Credentials', true); // Allow credentials
  next();
});

const port = process.env.PORT || 8080;

app.use('/products', productRoutes);

app.use('/users', userRoutes);

app.use('/orders', orderRoutes);

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});