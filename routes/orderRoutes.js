require('dotenv').config();
const express = require('express');
const { razorpay } = require("../razorpay")
const router = express.Router();
const Product = require('../models/product');
const ShortId = require('shortid')
require('dotenv').config()

const calculateAmount = async (uuid) => {
    const id = uuid;

  try{
    const user = await User.findOne({ uuid: id });
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    } else{
      const cart = user.cart.items;

      if(cart.length == 0){
        res.status(200).json([])
      } else {
        cartCopy = []

        cart.forEach( async (item) => {
          cartCopy.push(item)
        })

        const promises = cart.map(async (item) => {
          const product = await Product.findOne({ pid: item.id });
          if (product) {
            return {
              pid: item.id,
              name: product.name,
              desc: product.desc,
              price: product.price,
              imgUrl: product.imageUrl,
              type: product.type,
              qty: item.qty
            };
          }
          else return null; // Handle the case where the product is not found
        });

        const responseObject = await Promise.all(promises);

        var totalPrice = 0
        responseObject?.forEach((cartItem) => {
            totalPrice = totalPrice + (cartItem.price * cartItem.qty)
        })
        return totalPrice + 40 + 5 + 98.50;
      }
    }
  }
  catch(error){
    return 0; 
  }
}

router.post('/createOrder', async (req, res) => {

    const id = req.body.uuid

    const total = await calculateAmount(id)

    const options = {
        amount: total * 100, // amount in smallest currency unit
        receipt: Math.random(Date.now()).toString(),
        currency: "INR",
    };

    try {

        const paymentResponse = await razorpay.orders.create(options);

        res.status(200).json({
          id: paymentResponse.id,
          currency: paymentResponse.currency,
          amount: paymentResponse.amount
        });

    } catch (err) {
        res.status(500).json({ 
          'message': err  
        })
    }

});

module.exports = router;