# MongoDB Planet Data Import Guide

## Overview
This guide will help you populate your MongoDB Atlas database with planet data for the Solar System application.

## Data Structure

Each planet document contains:
- **id** (Number): Planet ID from 1-8
- **name** (String): Planet name (Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune)
- **image** (String): URL to planet image
- **velocity** (String): Orbital velocity
- **distance** (String): Distance from the Sun
- **description** (String): Detailed information about the planet

## Method 1: Using Node.js Import Script (Recommended)

### Step 1: Set Environment Variables

```bash
export MONGO_URI="your-mongodb-atlas-uri"
export MONGO_USERNAME="your-username"
export MONGO_PASSWORD="your-password"
```

### Step 2: Run Import Script

```bash
node import-planets.js
```

Expected output:
```
Connecting to MongoDB...
✅ Connected to MongoDB successfully!

Clearing existing planet data...
✅ Existing data cleared

Importing planet data...
✅ Successfully imported 8 planets!

Imported planets:
  - ID: 1, Name: Mercury
  - ID: 2, Name: Venus
  - ID: 3, Name: Earth
  - ID: 4, Name: Mars
  - ID: 5, Name: Jupiter
  - ID: 6, Name: Saturn
  - ID: 7, Name: Uranus
  - ID: 8, Name: Neptune

Verifying data...
✅ Total planets in database: 8

✅ Database connection closed. Import complete!
```

## Method 2: Using MongoDB Atlas Web Interface

### Step 1: Go to MongoDB Atlas
1. Log in to https://cloud.mongodb.com/
2. Navigate to your cluster
3. Click "Browse Collections"
4. Select database: `solar-system`
5. Select collection: `planets`

### Step 2: Insert Documents
Click "INSERT DOCUMENT" and paste each planet document:

#### Mercury
```json
{
  "id": 1,
  "name": "Mercury",
  "image": "https://gitlab.com/sidd-harth/solar-system/-/raw/main/images/mercury.png",
  "velocity": "47 km/s",
  "distance": "57.9 million km",
  "description": "Mercury is the smallest planet in the Solar System and the closest to the Sun. Its orbit around the Sun takes 87.97 Earth days, the shortest of all the Sun's planets. It is named after the Roman god Mercurius (Mercury), god of commerce, messenger of the gods, and mediator between gods and mortals."
}
```

#### Venus
```json
{
  "id": 2,
  "name": "Venus",
  "image": "https://gitlab.com/sidd-harth/solar-system/-/raw/main/images/venus.png",
  "velocity": "35 km/s",
  "distance": "108.2 million km",
  "description": "Venus is the second planet from the Sun. It is sometimes called Earth's 'sister' or 'twin' planet as it is almost as large and has a similar composition. As an interior planet to Earth, Venus (like Mercury) appears in Earth's sky never far from the Sun, either as morning star or evening star."
}
```

#### Earth
```json
{
  "id": 3,
  "name": "Earth",
  "image": "https://gitlab.com/sidd-harth/solar-system/-/raw/main/images/earth.png",
  "velocity": "29 km/s",
  "distance": "149.6 million km",
  "description": "Earth is the third planet from the Sun and is the largest of the terrestrial planets. The Earth is the only planet in our solar system not to be named after a Greek or Roman deity. The Earth was formed approximately 4.54 billion years ago and is the only known planet to support life. Earth has one Moon, the largest moon of any rocky planet in the Solar System."
}
```

#### Mars
```json
{
  "id": 4,
  "name": "Mars",
  "image": "https://gitlab.com/sidd-harth/solar-system/-/raw/main/images/mars.png",
  "velocity": "24 km/s",
  "distance": "227.9 million km",
  "description": "Mars is the fourth planet from the Sun and the second-smallest planet in the Solar System, being larger than only Mercury. In English, Mars carries the name of the Roman god of war and is often called the 'Red Planet'. The latter refers to the effect of the iron oxide prevalent on Mars's surface, which gives it a reddish appearance distinctive among the astronomical bodies visible to the naked eye."
}
```

#### Jupiter
```json
{
  "id": 5,
  "name": "Jupiter",
  "image": "https://gitlab.com/sidd-harth/solar-system/-/raw/main/images/jupiter.png",
  "velocity": "13 km/s",
  "distance": "778.5 million km",
  "description": "Jupiter is the fifth planet from the Sun and the largest in the Solar System. It is a gas giant with a mass more than two and a half times that of all the other planets in the Solar System combined, but slightly less than one-thousandth the mass of the Sun. Jupiter is the third brightest natural object in the Earth's night sky after the Moon and Venus."
}
```

#### Saturn
```json
{
  "id": 6,
  "name": "Saturn",
  "image": "https://gitlab.com/sidd-harth/solar-system/-/raw/main/images/saturn.png",
  "velocity": "9.7 km/s",
  "distance": "1.434 billion km",
  "description": "Saturn is the sixth planet from the Sun and the second-largest in the Solar System, after Jupiter. It is a gas giant with an average radius of about nine and a half times that of Earth. It has only one-eighth the average density of Earth; however, with its larger volume, Saturn is over 95 times more massive. Saturn's interior is most likely composed of a rocky core, surrounded by a deep layer of metallic hydrogen."
}
```

#### Uranus
```json
{
  "id": 7,
  "name": "Uranus",
  "image": "https://gitlab.com/sidd-harth/solar-system/-/raw/main/images/uranus.png",
  "velocity": "6.8 km/s",
  "distance": "2.871 billion km",
  "description": "Uranus is the seventh planet from the Sun. Its name is a reference to the Greek god of the sky, Uranus (Caelus), who, according to Greek mythology, was the great-grandfather of Ares (Mars), grandfather of Zeus (Jupiter) and father of Cronus (Saturn). It has the third-largest planetary radius and fourth-largest planetary mass in the Solar System."
}
```

#### Neptune
```json
{
  "id": 8,
  "name": "Neptune",
  "image": "https://gitlab.com/sidd-harth/solar-system/-/raw/main/images/neptune.png",
  "velocity": "5.4 km/s",
  "distance": "4.495 billion km",
  "description": "Neptune is the eighth planet from the Sun and the farthest known planet in the Solar System. It is the fourth-largest planet in the Solar System by diameter, the third-most-massive planet, and the densest giant planet. It is 17 times the mass of Earth, and slightly more massive than its near-twin Uranus. Neptune is denser and physically smaller than Uranus because its greater mass causes more gravitational compression of its atmosphere."
}
```

## Method 3: Using mongoimport Command Line

### Step 1: Install MongoDB Tools
```bash
# Ubuntu/Debian
sudo apt-get install mongodb-database-tools

# macOS
brew install mongodb-database-tools
```

### Step 2: Import JSON File
```bash
mongoimport --uri "your-mongodb-atlas-uri" \
  --username "your-username" \
  --password "your-password" \
  --db solar-system \
  --collection planets \
  --file planets-data.json \
  --jsonArray
```

## Verification

After importing, verify the data:

### Using Node.js
```bash
# Run the application
export MONGO_URI="your-uri"
export MONGO_USERNAME="your-username"
export MONGO_PASSWORD="your-password"
npm start

# Test endpoint
curl -X POST http://localhost:3000/planet \
  -H "Content-Type: application/json" \
  -d '{"id": 3}'
```

Expected response for Earth (id: 3):
```json
{
  "_id": "...",
  "id": 3,
  "name": "Earth",
  "image": "https://gitlab.com/sidd-harth/solar-system/-/raw/main/images/earth.png",
  "velocity": "29 km/s",
  "distance": "149.6 million km",
  "description": "Earth is the third planet from the Sun and is the largest of the terrestrial planets..."
}
```

### Using MongoDB Atlas
1. Go to Collections → solar-system → planets
2. You should see 8 documents (planets)
3. Each document should have: id, name, image, velocity, distance, description

## Troubleshooting

### Connection Error
**Problem**: Cannot connect to MongoDB
**Solution**: 
- Verify your connection string is correct
- Check Network Access in MongoDB Atlas (add 0.0.0.0/0 for testing)
- Verify username/password are correct

### Import Script Fails
**Problem**: `node import-planets.js` fails
**Solution**:
- Make sure `planets-data.json` exists in the same directory
- Verify environment variables are set correctly
- Check if mongoose is installed: `npm install`

### Data Not Showing
**Problem**: Application runs but no planet data returned
**Solution**:
- Verify database name is exactly `solar-system`
- Verify collection name is exactly `planets`
- Check if data was actually imported (use MongoDB Atlas interface)
- Verify the `id` field is a Number, not a String

## Testing with Unit Tests

After importing data, run the unit tests:
```bash
npm test
```

All 11 tests should pass if data is imported correctly:
- ✅ it should fetch a planet named Mercury
- ✅ it should fetch a planet named Venus
- ✅ it should fetch a planet named Earth
- ✅ it should fetch a planet named Mars
- ✅ it should fetch a planet named Jupiter
- ✅ it should fetch a planet named Saturn
- ✅ it should fetch a planet named Uranus
- ✅ it should fetch a planet named Neptune
- ✅ it should fetch OS details
- ✅ it checks Liveness endpoint
- ✅ it checks Readiness endpoint

## Next Steps

1. ✅ Import planet data using one of the methods above
2. ✅ Verify data in MongoDB Atlas
3. ✅ Test locally with `npm start`
4. ✅ Run unit tests with `npm test`
5. ✅ Add MongoDB credentials to GitHub Secrets
6. ✅ Push code to trigger DevSecOps pipeline

Good luck! 🚀
