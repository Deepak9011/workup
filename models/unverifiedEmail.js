const mongoose = require('mongoose');
const { v4: uuidv4 } = require('uuid');

const unverifiedEmailSchema = new mongoose.Schema(
    {
        uuid: {
            type: String,
            required: true,
            trim: true,
            unique: true,
            immutable: true,
            default: uuidv4
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
        otp: {
            type: String,
            trim: true,
        }
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

module.exports = mongoose.model("UnverifiedEmails", unverifiedEmailSchema);