/**
 * MongoDB Planet Data Import Script
 * 
 * This script imports planet data into MongoDB Atlas
 * Run with: node import-planets.js
 */

const mongoose = require('mongoose');
const fs = require('fs');

// Load planet data
const planetsData = JSON.parse(fs.readFileSync('planets-data.json', 'utf8'));

// MongoDB connection configuration
const MONGO_URI = process.env.MONGO_URI || 'your-mongodb-uri-here';
const MONGO_USERNAME = process.env.MONGO_USERNAME || 'your-username-here';
const MONGO_PASSWORD = process.env.MONGO_PASSWORD || 'your-password-here';

// Define the same schema as in app.js
const Schema = mongoose.Schema;
const dataSchema = new Schema({
    name: String,
    id: Number,
    description: String,
    image: String,
    velocity: String,
    distance: String
});

const PlanetModel = mongoose.model('planets', dataSchema);

// Connect to MongoDB and import data
async function importPlanets() {
    try {
        // Connect to MongoDB
        console.log('Connecting to MongoDB...');
        await mongoose.connect(MONGO_URI, {
            user: MONGO_USERNAME,
            pass: MONGO_PASSWORD,
            useNewUrlParser: true,
            useUnifiedTopology: true
        });
        console.log('✅ Connected to MongoDB successfully!\n');

        // Clear existing data (optional - comment out if you want to keep existing data)
        console.log('Clearing existing planet data...');
        await PlanetModel.deleteMany({});
        console.log('✅ Existing data cleared\n');

        // Insert new planet data
        console.log('Importing planet data...');
        const result = await PlanetModel.insertMany(planetsData);
        console.log(`✅ Successfully imported ${result.length} planets!\n`);

        // Display imported planets
        console.log('Imported planets:');
        result.forEach(planet => {
            console.log(`  - ID: ${planet.id}, Name: ${planet.name}`);
        });

        // Verify the data
        console.log('\nVerifying data...');
        const count = await PlanetModel.countDocuments();
        console.log(`✅ Total planets in database: ${count}`);

        // Close connection
        await mongoose.connection.close();
        console.log('\n✅ Database connection closed. Import complete!');
        
    } catch (error) {
        console.error('❌ Error importing planets:', error.message);
        process.exit(1);
    }
}

// Run the import
importPlanets();
