const mongoose = require('mongoose');
const languages = require('../data/languages');
const locations = require('../data/locations');
const religions = require('../data/religions')

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
    required: true
  }
});

const customerSchema = new mongoose.Schema(
    {
        uuid: {
            type: String,
            required: true,
            trim: true,
            unique: true,
            immutable: true
        },
        firstName: {
            type: String,
            maxlength: 20,
            required: true,
            trim: true,
        },
        middleName: {
            type: String,
            maxlength: 20,
            required: true,
            trim: true,
        },
        lastName: {
            type: String,
            maxlength: 20,
            required: true,
            trim: true,
        },
        dateOfBirth: {
            type: Date,
            required: true,
        },
        imgUrl: {
            type: String,
            trim: true
        },
        imgPublicId: {
            type: String,
            trim: true
        },
        email: {
            type: String,
            trim: true,
            lowercase: true,
        },
        password: {
            type: String,
            trim: true,
        },
        phoneNumber: {
            type: String,
            unique: true,
            required: true,
            trim: true,
        },
        languages: [],
        joiningDate: {
            type: Date,
            trim: true
        },
        religion: {
            type: String,
            trim: true,
            enum: religions.religions
        },
        addressLine1: {
            type: String,
            trim: true,
        },
        addressLine2: {
            type: String,
            trim: true,
        },
        city: {
            type: String,
            trim: true,
            enum: locations.cities
        },
        state: {
            type: String,
            trim: true,
            enum: locations.states
        },
        zipCode: {
            type: Number,
            trim: true,
        },
        location: geoCoordinateSchema,
    } 
);

customerSchema.pre('save', async function(next) {
  const user = this;
  if (!user.isModified('password')) return next();
  
  try {
    const hashedPassword = await bcrypt.hash(user.password, 10); // 10 is the saltRounds
    user.password = hashedPassword;
    next();
  } catch (error) {
    return next(error);
  }
});

module.exports = mongoose.model("Customer", customerSchema);