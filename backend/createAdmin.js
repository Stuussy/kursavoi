require('dotenv').config();
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

// MongoDB connection string
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/munchly';

// User schema (same as in models/User.js)
const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  name: { type: String, required: true },
  phone: String,
  role: { type: String, enum: ['user', 'admin'], default: 'user' },
}, { timestamps: true });

const User = mongoose.model('User', userSchema);

async function createAdminUser() {
  try {
    // Connect to MongoDB
    await mongoose.connect(MONGODB_URI);
    console.log('Connected to MongoDB');

    // Check if admin already exists
    const existingAdmin = await User.findOne({ email: 'admin@munchly.com' });

    if (existingAdmin) {
      console.log('Admin user already exists!');
      console.log('Email: admin@munchly.com');
      console.log('Password: admin123');
      await mongoose.disconnect();
      return;
    }

    // Hash password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash('admin123', salt);

    // Create admin user
    const admin = new User({
      email: 'admin@munchly.com',
      password: hashedPassword,
      name: 'Admin',
      phone: '+7 777 777 7777',
      role: 'admin',
    });

    await admin.save();

    console.log('✅ Admin user created successfully!');
    console.log('');
    console.log('Admin credentials:');
    console.log('Email: admin@munchly.com');
    console.log('Password: admin123');
    console.log('');
    console.log('You can now login with these credentials.');

    await mongoose.disconnect();
  } catch (error) {
    console.error('Error creating admin user:', error);
    process.exit(1);
  }
}

createAdminUser();
