const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema(
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
    tableId: {
      type: String,
      required: [true, 'Table ID is required'],
    },
    tableNumber: {
      type: Number,
      required: [true, 'Table number is required'],
    },
    date: {
      type: String,
      required: [true, 'Date is required'],
      match: [/^\d{4}-\d{2}-\d{2}$/, 'Date must be in YYYY-MM-DD format'],
    },
    time: {
      type: String,
      required: [true, 'Time is required'],
      match: [/^\d{2}:\d{2}$/, 'Time must be in HH:MM format'],
    },
    guests: {
      type: Number,
      required: [true, 'Number of guests is required'],
      min: [1, 'At least 1 guest is required'],
    },
    status: {
      type: String,
      enum: ['pending', 'confirmed', 'cancelled', 'completed'],
      default: 'confirmed',
    },
  },
  {
    timestamps: true,
  }
);

// Transform output to match API spec
bookingSchema.methods.toJSON = function () {
  const obj = this.toObject();
  obj.id = obj._id.toString();
  obj.userId = obj.userId.toString();
  delete obj._id;
  delete obj.__v;
  delete obj.updatedAt;
  return obj;
};

const Booking = mongoose.model('Booking', bookingSchema);

module.exports = Booking;
