require('dotenv').config();

const mongo = {
    url: process.env.MONGODB_URL
}

module.exports = mongo; 