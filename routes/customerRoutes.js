const express = require('express');
const router = express.Router();
const Product = require('../models/product');
const UnverifiedEmail = require('../models/unverifiedEmail');
const bcrypt = require('bcrypt');
const multer = require('multer');
const Order = require('../models/order');
const cloudinary = require('cloudinary').v2;
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');
const { transporter } = require('../utils/email');
const Customer = require('../models/customer');
require('dotenv').config();

cloudinary.config({
    cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
    api_key: process.env.CLOUDINARY_API_KEY,
    api_secret: process.env.CLOUDINARY_API_SECRET,
})

const upload = multer({ storage: multer.memoryStorage() });

//body params: uuid, name, email

/* response:
  message: String
*/

router.post('/register', async (req, res) => {

  const email = req.body.email;
  const password = req.body.password;

  await UnverifiedEmail.findOneAndDelete({email: email})

  const hashedPassword = await bcrypt.hash(password, 10);

  const otp = Math.floor(100000 + Math.random() * 900000).toString();

  const unverifiedEmail = new UnverifiedEmail(
    {
      email: email,
      password: hashedPassword,
      otp: otp
    }
  )

  try{
    await unverifiedEmail.save().then(() => {

      res.send({message: `Verify Email`});

      let mailOptions = {
        from: `Work Up <${process.env.EMAIL_USER}>`, // Sender address
        to: `${email}`, // List of receivers
        subject: 'Work Up email verification', // Subject line
        text: `Your OTP for verification is ${otp}`, // Plain text body
        html: `<div style="max-width: 400px; margin: 0 auto; padding: 20px; border: 1px solid #ccc; border-radius: 8px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); text-align: center; background-color: #f9f9f9;"><h2 style="margin-bottom: 20px; font-size: 24px; color: #333;">OTP Verification</h2><p style="font-size: 18px; margin-bottom: 20px;">Your OTP for verification is <strong style="font-size: 36px; font-weight: bold; color: #28a745;">${otp}</strong></p></div>`// HTML body
      };

      transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
          return console.log(error);
        }
        console.log('Message sent: %s', info.messageId);
        console.log('Preview URL: %s', nodemailer.getTestMessageUrl(info));
      });
    });
  }
  catch(err){
      res.status(400).send(err.message);
  }

})

router.post('/verify', async (req, res) => {

  const email = req.body.email;
  const otp = req.body.otp;

  try{
      await UnverifiedEmail.findOne({email: email}).then( async (uvemail) =>{

        if(uvemail.otp == otp){
          
          const customer = new Customer(
            {
              email: uvemail.email,
              password: uvemail.password,
            }
          )

          try{
            await customer.save().then(async () => {
              try{
                await UnverifiedEmail.deleteOne({ _id: uvemail._id }).then(() => {
                  res.status(200).send({message: "Verification successful"});
                });
                
              } catch (err) {
                res.json({message: err.message});
              }
            });
          } catch (err){
            res.json({message: err.message});
          }
        } else {
          res.status(400).send({message: "Verification unsuccessful"});
        }
      })

  }catch(err){
      res.json({message: err.message});
  }  
  
});

router.post('/login', async (req, res) => {
  const email = req.body.email;
  const password = req.body.password;

  try {
    const customer = await Customer.findOne({ email: email });
    if (!customer) {
      return res.status(400).json({ message: 'Invalid Email', code: 'InvalidEmail' });
    }

    const isMatch = await bcrypt.compare(password, customer.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid Password', code: 'InvalidCode' });
    }
    
    const token = jwt.sign({ userId: customer._id }, process.env.JWT_SECRET, { expiresIn: '30d' });

    res.json({ token, code: "Success" });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error, code: "Error" });
  }
});

router.post('/verifyToken', async (req, res) => {
  const email = req.body.email;
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  try {
    const customer = await Customer.findOne({ email: email });
    if (!customer) {
      return res.status(400).json({ message: 'Invalid Email', code: 'InvalidEmail' });
    }

    jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
      if (err) return res.Status(403).json({ message: "Unverified", code: "unverified" });
      if(customer._id == user.userId){
        res.status(200).send({message: "Verified", code: "verified"})
      }
    });

  } catch (error) {
    res.status(500).json({ message: 'Server error', error, code: "Error" });
  }
});

router.post('/googleLogin', upload.single('image'), async (req, res) => {

  const photoUrl = req.body.photoUrl

  var imgPublicId =""

  await User.findOne({uuid: req.body.uuid}).then( async (user) => {
    if(user == null){
      try {
        await cloudinary.uploader.upload( photoUrl, {
          folder: 'foodhub/users',
          resource_type: 'image',
        }).then( async (result) => {
          imgPublicId = result.public_id
          const optimizedUrl = cloudinary.url(imgPublicId, {
              fetch_format: 'auto',
              quality: 'auto'
          });
          try{
            const user = new User({
                uuid: req.body.uuid,
                name: req.body.name,
                email: req.body.email,
                imgUrl: optimizedUrl,
                imgPublicId: imgPublicId
            });

            try{
              const savedUser = await user.save();
              res.send({message: `${savedUser.name} is now logged in`});
            }
            catch(err){
                res.status(400).send(err.message);
            }
          }catch(err){
            res.status(400).send(err.message);
          }
        })
      } catch (error) {
        res.status(500).send('Error adding user item');
      }
    }
  })
})

//body params: uuid

/* response:
    {
      name: String,
      email: String,
      phone: String,
      addressLine1: String,
      addressLine2: String,
      state: String
    }
*/

router.post('/userDetails', async (req, res) => {

  const id = req.body.uuid
  console.log(id)

  try{
      await User.findOne({uuid: id}).then((user) =>{

        responseObject = {
          name: user.name,
          email: user.email? user.email : "",
          phone: user.phone? user.phone : "",
          addressLine1: user.addressLine1? user.addressLine1 : "",
          addressLine2: user.addressLine2? user.addressLine2 : "",
          state: user.state? user.state : "",
          imgUrl: user.imgUrl? user.imgUrl : ""
        }

        res.json(responseObject)
      })

  }catch(err){
      res.json({message: err.message});
  }
});

router.put('/editUserDetails', async (req, res) => {

  const id = req.body.uuid
  console.log(id)

  try{
      await User.findOne({uuid: id}).then( async (user) =>{

        user.name = req.body.name? req.body.name : user.name
        user.email = req.body.email? req.body.email : user.email
        user.phone = req.body.phone? req.body.phone : user.phone
        user.addressLine1 = req.body.addressLine1? req.body.addressLine1 : user.addressLine1
        user.addressLine2 = req.body.addressLine2? req.body.addressLine2 : user.addressLine2
        user.state = req.body.state? req.body.state : user.state

        await user.save().then(() => {
          res.status(200).json({ message: "User details updated successfully"})
        })
      })

  }catch(err){
      res.json({message: err.message});
  }
});

//body params: uuid, password

/* response:
    {
      message: String
    }
*/

router.delete('/deleteUser', async (req, res) => {

  const id = req.body.uuid
  var givenPassword

  if('password' in req.body.uuid){
    givenPassword = req.body.password
  }

  try{
      const user = await User.findOne({ uuid: id});

      if('password' in user){
        bcrypt.compare(givenPassword, user.password, async (err, result) => {
          if (err) {
            res.json({message: err.message})
          } else if (result) {
            await User.deleteOne({ uuid: user.uuid}).then((user) => res.json({ message: `${user.name} was deleted`}))
          } else {
            res.json({ message: "Password didn't match"})
          }
        });
      }

      res.json({
        userDetails: responseObject
      })
  }catch(err){
      res.json({message: err.message});
  }
});

//body params: uuid

/* response:
    {
      name: String,
      desc: String,
      price: Number,
      imgUrl: String,
      region: String,
      type: String,
    }
*/

router.post('/cart', async (req, res) => {

  const id = req.body.uuid

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
          return null; // Handle the case where the product is not found
        });

        const responseObject = await Promise.all(promises);

        res.json(responseObject)
      }
    }
  }
  catch(error){
    res.status(400).json({ message: error.message }); 
  }
})

//body params: uuid, pid[]

/* response:
    {
      message: String
    }
*/

router.post('/addToCart', async (req, res) => {

  const id = req.body.uuid
  const pid = req.body.pid

  await User.findOne({ uuid: id }).then( async (user) => {
    var foundFlag = false
    user.cart.items.forEach((addedItem) => {
      if(pid == addedItem.id){
        addedItem.qty = addedItem.qty + 1
        foundFlag = true
      }
    })

    if(!foundFlag){
      user.cart.items.push(
        {
          'id': pid,
          'qty': 1
        }
      )
    }
  
    try{
      await user.save()
      res.status(200).json({message: 'Successfully added to cart'})
    }
    catch(error){
      res.status(400).json({ message: err.message }); 
    }
  })
})

router.delete('/deleteFromCart', async (req, res) => {
  const id = req.body.uuid
  const pid = req.body.pid

  await User.findOne({ uuid: id }).then( async (user) => {
    
    user.cart.items.forEach((addedItem) => {
      if(pid == addedItem.id){
        addedItem.qty = addedItem.qty - 1
        if(addedItem.qty == 0){
          user.cart.items.remove(addedItem)
        }
      }
    })
  
    try{
      await user.save()
      res.status(200).json({message: 'Successfully removed from cart'})
    }
    catch(error){
      res.status(400).json({ message: err.message }); 
    }
  })
})

router.delete('/deleteItemFromCart', async (req, res) => {
  const id = req.body.uuid
  const pid = req.body.pid

  await User.findOne({ uuid: id }).then( async (user) => {
    
    user.cart.items.forEach((addedItem) => {
      if(pid == addedItem.id){
        user.cart.items.remove(addedItem)
      }
    })
  
    try{
      await user.save()
      res.status(200).json({message: 'Successfully removed Item from cart'})
    }
    catch(error){
      res.status(400).json({ message: err.message }); 
    }
  })
})

router.post('/placeOrder', async (req, res) => {
  const id = req.body.uuid

  await User.findOne({ uuid: id }).then( async (user) => {
    
    const order = new Order({
      items: user.cart.items,
      uuid: id,
    })
  
    try{
      await order.save().then( async () => {
        user.cart.items = []
        await user.save().then(() => {
          res.status(200).json({message: 'Order placed'})
        })
      })
    }
    catch(error){
      res.status(400).json({ message: err.message }); 
    }
  })
})

module.exports = router;