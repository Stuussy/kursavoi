const mongoose = require('mongoose');

const favoriteSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'User ID is required'],
    },
    restaurantId: {
      type: String,
      required: [true, 'Restaurant ID is required'],
    },
    restaurantName: {
      type: String,
      required: [true, 'Restaurant name is required'],
    },
    cuisine: {
      type: String,
      required: true,
    },
    rating: {
      type: Number,
      required: true,
    },
    reviewCount: {
      type: Number,
      default: 0,
    },
    address: {
      type: String,
      required: true,
    },
    priceRange: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      required: true,
    },
    isOpen: {
      type: Boolean,
      default: true,
    },
  },
  {
    timestamps: true,
  }
);

// Create compound index to ensure one favorite per user per restaurant
favoriteSchema.index({ userId: 1, restaurantId: 1 }, { unique: true });

// Transform output to match API spec
favoriteSchema.methods.toJSON = function () {
  const obj = this.toObject();
  obj.id = obj._id.toString();
  obj.userId = obj.userId.toString();
  delete obj._id;
  delete obj.__v;
  delete obj.updatedAt;
  return obj;
};

const Favorite = mongoose.model('Favorite', favoriteSchema);

module.exports = Favorite;
