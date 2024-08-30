const mongoose = require('mongoose');
const languages = require('../data/languages');
const locations = require('../data/locations');
const religions = require('../data/religions')
const { v4: uuidv4 } = require('uuid');

const cartItemSchema = new mongoose.Schema({
    id: {
        type: String,
    },
    qty: {
        type: Number,
        min: 0,
        max: 100
    }
});

const geoCoordinateSchema = new mongoose.Schema({
    y: {
        type: Number
    },
    x: {
        type: Number
    }
});

const languagesSchema = new mongoose.Schema({
  role: {
    type: String,
    enum: languages.languages,
  }
});

const customerSchema = new mongoose.Schema(
    {
        uuid: {
            type: String,
            required: true,
            trim: true,
            unique: true,
            immutable: true,
            default: uuidv4
        },
        firstName: {
            type: String,
            maxlength: 20,
            trim: true,
            default: null
        },
        middleName: {
            type: String,
            maxlength: 20,
            trim: true,
            default: null
        },
        lastName: {
            type: String,
            maxlength: 20,
            trim: true,
            default: null
        },
        dateOfBirth: {
            type: Date,
            default: null,
        },
        imgUrl: {
            type: String,
            trim: true,
            default: null
        },
        imgPublicId: {
            type: String,
            trim: true,
            default: null
        },
        email: {
            type: String,
            trim: true,
            lowercase: true,
            required: true
        },
        password: {
            type: String,
            trim: true,
            required: true,
        },
        phoneNumber: {
            type: String,
            unique: true,
            trim: true,
            default: null
        },
        languages: [],
        joiningDate: {
            type: Date,
            trim: true,
            default: Date.now()
        },
        religion: {
            type: String,
            trim: true,
            enum: religions.religions,
            default: null
        },
        addressLine1: {
            type: String,
            trim: true,
            default: null
        },
        addressLine2: {
            type: String,
            trim: true,
            default: null
        },
        city: {
            type: String,
            trim: true,
            enum: locations.cities,
            default: null
        },
        state: {
            type: String,
            trim: true,
            enum: locations.states,
            default: null
        },
        zipCode: {
            type: Number,
            trim: true,
            default: null
        },
        location: geoCoordinateSchema,
    } 
);

// customerSchema.pre('save', async function(next) {
//   const user = this;
//   if (!user.isModified('password')) return next();
  
//   try {
//     const hashedPassword = await bcrypt.hash(user.password, 10); // 10 is the saltRounds
//     user.password = hashedPassword;
//     next();
//   } catch (error) {
//     return next(error);
//   }
// });

module.exports = mongoose.model("Customer", customerSchema);