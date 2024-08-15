const mongoose = require('mongoose');
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

const orderSchema = new mongoose.Schema(
    {
        orderId: {
            type: String,
            required: true,
            trim: true,
            unique: true,
            immutable: true,
            default: uuidv4
        },
        uuid: {
            type: String,
            required: true,
            trim: true,
            immutable: true
        },
        dateTime: {
            type: Date,
            required: true,
            unique: true,
            immutable: true,
            default: Date.now
        },
        items: [cartItemSchema]
    } 
);

// userSchema.pre('save', async function(next) {
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

module.exports = mongoose.model("Order", orderSchema);