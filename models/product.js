const mongoose = require('mongoose');
const { v4: uuidv4 } = require('uuid');

const productSchema = new mongoose.Schema(
    {
        pid: {
            type: String,
            required: true,
            trim: true,
            unique: true,
            immutable: true,
            default: uuidv4
        },
        name: {
            type: String,
            required: true,
            trim: true
        },
        desc: {
            type: String,
            required: true,
            trim: true
        },
        price: {
            type: Number,
            required: true,
            trim: true
        },
        imageUrl: {
            type: String,
            required: true,
            trim: true
        },
        imagePublicId: {
            type: String,
            required: true,
            trim: true
        },
        type: {
            type: String,
            required: true,
            trim: true,
            enum: ['Indian', 'Chinese', 'Italian', 'Japanese', 'Mexican', 'Breakfast', 'Drink', 'Starter', 'Dessert']
        },
    } 
);

module.exports = mongoose.model("Product", productSchema);