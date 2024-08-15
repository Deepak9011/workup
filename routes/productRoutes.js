const express = require('express');
const router = express.Router();
const Product = require('../models/product');
const multer = require('multer')
const cloudinary = require('cloudinary').v2;

cloudinary.config({
    cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
    api_key: process.env.CLOUDINARY_API_KEY,
    api_secret: process.env.CLOUDINARY_API_SECRET,
})

const upload = multer({ storage: multer.memoryStorage() });

router.get('/all', async (req, res) => {
    try{
        const products = await Product.find();
        var response = []
        products.forEach((product) => {
          response.push({
            pid: product.pid,
            type: product.type,
            desc: product.desc,
            name: product.name,
            price: product.price,
            imageUrl: product.imageUrl
          })
        })
        res.json(response);
    }catch(err){
        res.json({message: err});
    }
});

router.get('/breakfast', async (req, res) => {
  try{
    const products = await Product.find({type: 'Breakfast'});
    var response = []
    products.forEach((product) => {
      response.push({
        pid: product.pid,
        type: product.type,
        desc: product.desc,
        name: product.name,
        price: product.price,
        imageUrl: product.imageUrl
      })
    })
    res.send(response);
  }catch(err){
    res.status(400).send(err.message); 
  }
})

router.get('/dessert', async (req, res) => {
  try{
    const products = await Product.find({type: 'Dessert'});
    var response = []
    products.forEach((product) => {
      response.push({
        pid: product.pid,
        type: product.type,
        desc: product.desc,
        name: product.name,
        price: product.price,
        imageUrl: product.imageUrl
      })
    })
    res.send(response);
  }catch(err){
    res.status(400).send(err.message); 
  }
})

router.get('/drink', async (req, res) => {
  try{
    const products = await Product.find({type: 'Drink'});
    var response = []
    products.forEach((product) => {
      response.push({
        pid: product.pid,
        type: product.type,
        desc: product.desc,
        name: product.name,
        price: product.price,
        imageUrl: product.imageUrl
      })
    })
    res.send(response);
  }catch(err){
    res.status(400).send(err.message); 
  }
})

router.get('/starter', async (req, res) => {
  try{
    const products = await Product.find({type: 'Starter'});
    var response = []
    products.forEach((product) => {
      response.push({
        pid: product.pid,
        type: product.type,
        desc: product.desc,
        name: product.name,
        price: product.price,
        imageUrl: product.imageUrl
      })
    })
    res.send(response);
  }catch(err){
    res.status(400).send(err.message); 
  }
})

router.get('/chinese', async (req, res) => {
  try{
    const products = await Product.find({type: 'Chinese'});
    var response = []
    products.forEach((product) => {
      response.push({
        pid: product.pid,
        type: product.type,
        desc: product.desc,
        name: product.name,
        price: product.price,
        imageUrl: product.imageUrl
      })
    })
    res.send(response);
  }catch(err){
    res.status(400).send(err.message); 
  }
})

router.get('/japanese', async (req, res) => {
  try{
    const products = await Product.find({type: 'Japanese'});
    var response = []
    products.forEach((product) => {
      response.push({
        pid: product.pid,
        type: product.type,
        desc: product.desc,
        name: product.name,
        price: product.price,
        imageUrl: product.imageUrl
      })
    })
    res.send(response);
  }catch(err){
    res.status(400).send(err.message); 
  }
})

router.get('/indian', async (req, res) => {
  try{
    const products = await Product.find({type: 'Indian'});
    var response = []
    products.forEach((product) => {
      response.push({
        pid: product.pid,
        type: product.type,
        desc: product.desc,
        name: product.name,
        price: product.price,
        imageUrl: product.imageUrl
      })
    })
    res.send(response);
  }catch(err){
    res.status(400).send(err.message); 
  }
})

router.get('/italian', async (req, res) => {
  try{
    const products = await Product.find({type: 'Italian'});
    var response = []
    products.forEach((product) => {
      response.push({
        pid: product.pid,
        type: product.type,
        desc: product.desc,
        name: product.name,
        price: product.price,
        imageUrl: product.imageUrl
      })
    })
    res.send(response);
  }catch(err){
    res.status(400).send(err.message); 
  }
})

router.get('/mexican', async (req, res) => {
  try{
    const products = await Product.find({type: 'Mexican'});
    var response = []
    products.forEach((product) => {
      response.push({
        pid: product.pid,
        type: product.type,
        desc: product.desc,
        name: product.name,
        price: product.price,
        imageUrl: product.imageUrl
      })
    })
    res.send(response);
  }catch(err){
    res.status(400).send(err.message); 
  }
})

router.post('/new', upload.single('image'), async (req, res) => { //'image' is the name of the body parameter for file

  var imgPublicId =""

  try {
    const uploadStream = cloudinary.uploader.upload_stream(
      {
        folder: 'foodhub/menu',
        resource_type: 'image',
      },
      async (error, result) => {
        if (error) {
          return res.status(500).send('Error uploading image to Cloudinary');
        }
        imgPublicId = result.public_id
        const optimizedUrl = cloudinary.url(imgPublicId, {
            fetch_format: 'auto',
            quality: 'auto'
        });
        try{
          const product = new Product({
              name: req.body.name,
              desc: req.body.desc,
              price: parseInt(req.body.price, 10),
              imageUrl: optimizedUrl,
              imagePublicId: imgPublicId,
              type: req.body.type
          });

          try{
              const savedProduct = await product.save();
              const response = {
                pid: savedProduct.pid,
                type: savedProduct.type,
                desc: savedProduct.desc,
                name: savedProduct.name,
                price: savedProduct.price,
                imageUrl: savedProduct.imageUrl
              }
              res.send(response);
          }
          catch(err){
              res.status(400).send(err.message);
          }
        }catch(err){
          res.status(400).send(err.message);
        }
      }
    );

    uploadStream.end(req.file.buffer);
    
  } catch (error) {
    res.status(500).send('Error adding food item');
  }
});

router.put('/edit', upload.single('image'), async (req, res) => {
  const { pid, name, price, desc, type } = req.body;
  const file = req.file;

  try {
    const product = await Product.findOne({pid: pid});

    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }

    if (file) {
      // Promisify cloudinary.uploader.upload_stream
      const uploadStream = () =>
        new Promise((resolve, reject) => {
          const stream = cloudinary.uploader.upload_stream(
            { resource_type: 'image' },
            (error, result) => {
              if (error) {
                return reject('Cloudinary upload failed');
              }
              resolve(result);
            }
          );
          stream.end(file.buffer);
        });

      const result = await uploadStream();

      // Delete the old image from Cloudinary
      if (product.imagePublicId) {
        await cloudinary.uploader.destroy(product.imagePublicId);
      }

      // Update product details with new image
      product.imagePublicId = result.public_id;
      const optimizedUrl = cloudinary.url(result.public_id, {
        fetch_format: 'auto',
        quality: 'auto'
      });
      product.imageUrl = optimizedUrl;
    }

    // Update product details
    product.name = name;
    product.price = price;
    product.desc = desc;
    product.type = type;

    await product.save();

    res.json(product);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
})

router.delete('/delete', upload.single('image'), async (req, res) => {

  const { pid } = req.body;

  try{
    await Product.findOne({pid: pid}).then( async (product) => {
      await cloudinary.uploader.destroy(product.imagePublicId).then( async ()=> {
        await Product.deleteOne({ pid: pid}).then(() => res.json({ message: `Item was deleted`}))
      })
    })
  }catch(err){
    res.status(400).send(err.message);
  }
})

module.exports = router;