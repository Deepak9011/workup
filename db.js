const mongoose = require('mongoose');
const mongo = require('./mongo');

const url = mongo.url

const connectDB = async () =>{
    try{
        await mongoose.connect(url);
        console.log("MongoDB connection SUCCESS");
    }
    catch(err){
        console.log(err.message);
    }
}

module.exports = connectDB;