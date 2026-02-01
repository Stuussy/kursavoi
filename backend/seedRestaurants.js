require('dotenv').config();
const mongoose = require('mongoose');
const Restaurant = require('./src/models/Restaurant');

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/munchly';

// Sample restaurants with Unsplash images (CORS-friendly)
const sampleRestaurants = [
  {
    name: 'La Piazza Italiana',
    description: 'Түпнұсқа итальяндық асхана. Үйде жасалған паста, пицца және тамаша шарап таңдауы. Италиядан келген аспаздар дайындайды.',
    cuisine: 'Italian',
    address: 'Алматы, Абай даңғылы 44',
    phone: '+7 (727) 123-45-67',
    rating: 4.8,
    reviewCount: 256,
    priceRange: '$$$',
    imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&q=80',
    openingHours: [
      'Дүйсенбі - Жұма: 11:00 - 23:00',
      'Сенбі - Жексенбі: 12:00 - 00:00',
    ],
    tables: [
      { number: 1, capacity: 2, location: 'Терезе жанында', isAvailable: true },
      { number: 2, capacity: 2, location: 'Терезе жанында', isAvailable: true },
      { number: 3, capacity: 4, location: 'Орталық', isAvailable: true },
      { number: 4, capacity: 4, location: 'Орталық', isAvailable: true },
      { number: 5, capacity: 6, location: 'VIP бөлме', isAvailable: true },
      { number: 6, capacity: 8, location: 'Үлкен зал', isAvailable: true },
    ],
    isOpen: true,
  },
  {
    name: 'Sakura Japanese',
    description: 'Жапондық дәстүрлі асхана. Жаңа суши, сашими және рамен. Жапониядан тікелей жеткізілетін теңіз өнімдері.',
    cuisine: 'Japanese',
    address: 'Алматы, Достық даңғылы 89',
    phone: '+7 (727) 234-56-78',
    rating: 4.6,
    reviewCount: 189,
    priceRange: '$$$',
    imageUrl: 'https://images.unsplash.com/photo-1579027989536-b7b1f875659b?w=800&q=80',
    openingHours: [
      'Дүйсенбі - Жұма: 12:00 - 22:00',
      'Сенбі - Жексенбі: 12:00 - 23:00',
    ],
    tables: [
      { number: 1, capacity: 2, location: 'Суши бар', isAvailable: true },
      { number: 2, capacity: 2, location: 'Суши бар', isAvailable: true },
      { number: 3, capacity: 4, location: 'Татами бөлме', isAvailable: true },
      { number: 4, capacity: 4, location: 'Татами бөлме', isAvailable: true },
      { number: 5, capacity: 6, location: 'Жеке бөлме', isAvailable: true },
    ],
    isOpen: true,
  },
  {
    name: 'Burger House',
    description: 'Ең дәмді бургерлер қаласында! Жаңа ет, үйде пісірілген булочкалар және құпия соустар. Американдық классика.',
    cuisine: 'American',
    address: 'Алматы, Жібек Жолы 50',
    phone: '+7 (727) 345-67-89',
    rating: 4.5,
    reviewCount: 342,
    priceRange: '$$',
    imageUrl: 'https://images.unsplash.com/photo-1466978913421-dad2ebd01d17?w=800&q=80',
    openingHours: [
      'Күнделікті: 10:00 - 00:00',
    ],
    tables: [
      { number: 1, capacity: 2, location: 'Бар жанында', isAvailable: true },
      { number: 2, capacity: 2, location: 'Бар жанында', isAvailable: true },
      { number: 3, capacity: 4, location: 'Орталық', isAvailable: true },
      { number: 4, capacity: 4, location: 'Орталық', isAvailable: true },
      { number: 5, capacity: 6, location: 'Терраса', isAvailable: true },
      { number: 6, capacity: 8, location: 'Терраса', isAvailable: true },
    ],
    isOpen: true,
  },
  {
    name: 'Taj Mahal',
    description: 'Үнді асханасының ең жақсы дәмдері. Тандыр нан, карри және масала. Түпнұсқа рецепттер мен дәстүрлі дәмдер.',
    cuisine: 'Indian',
    address: 'Алматы, Гоголь көшесі 1',
    phone: '+7 (727) 456-78-90',
    rating: 4.7,
    reviewCount: 178,
    priceRange: '$$',
    imageUrl: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800&q=80',
    openingHours: [
      'Дүйсенбі - Жұма: 11:00 - 22:00',
      'Сенбі - Жексенбі: 12:00 - 23:00',
    ],
    tables: [
      { number: 1, capacity: 2, location: 'Терезе жанында', isAvailable: true },
      { number: 2, capacity: 4, location: 'Орталық', isAvailable: true },
      { number: 3, capacity: 4, location: 'Орталық', isAvailable: true },
      { number: 4, capacity: 6, location: 'Жеке бөлме', isAvailable: true },
      { number: 5, capacity: 8, location: 'Үлкен зал', isAvailable: true },
    ],
    isOpen: true,
  },
];

async function seedRestaurants() {
  try {
    // Connect to MongoDB
    await mongoose.connect(MONGODB_URI);
    console.log('MongoDB-ге қосылды');

    // Check if restaurants already exist
    const existingCount = await Restaurant.countDocuments();
    if (existingCount > 0) {
      console.log(`Дерекқорда ${existingCount} ресторан бар. Жаңа ресторандар қосылмады.`);
      console.log('Барлық ресторандарды жою және қайта қосу үшін --force флагын қолданыңыз.');

      if (process.argv.includes('--force')) {
        console.log('\n--force флагы анықталды. Барлық ресторандар жойылуда...');
        await Restaurant.deleteMany({});
        console.log('Барлық ресторандар жойылды.');
      } else {
        await mongoose.disconnect();
        return;
      }
    }

    // Insert sample restaurants
    const result = await Restaurant.insertMany(sampleRestaurants);
    console.log(`\n${result.length} ресторан сәтті қосылды:`);

    result.forEach((restaurant, index) => {
      console.log(`  ${index + 1}. ${restaurant.name} (${restaurant.cuisine})`);
    });

    console.log('\nДайын! Қолданбаны іске қосыңыз.');

  } catch (error) {
    console.error('Қате:', error.message);
  } finally {
    await mongoose.disconnect();
    console.log('\nMongoDB-ден ажыратылды.');
  }
}

seedRestaurants();
