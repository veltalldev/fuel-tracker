# Technical Stack and Architecture

## Essential Dependencies
- flutter_riverpod: State management
- sqflite: Local database
- intl: Date/number formatting

## Architecture
Simple three-layer architecture:
1. UI Layer (Screens & Widgets)
2. Repository Layer (Data operations)
3. Models (Data structures)

## Data Models

```dart
// Phase 1: Single Vehicle Fuel Entry Model
class FuelEntry {
  final int? id;
  final DateTime date;      // defaults to current date/time
  final double odometerReading;
  final double fuelVolume;
  final double pricePerUnit;
  final double totalCost;
  final String? location;   // defaults to current location if permitted

  // Calculated fields
  double? milesPerGallon;  // Calculated from previous entry
}

// Phase 2: Vehicle Model (Added later)
class Vehicle {
  final int? id;
  final String name;        // e.g., "My Honda Civic"
  final String? make;       // e.g., "Honda"
  final String? model;      // e.g., "Civic"
  final String? year;       // e.g., "2020"
}
```

## Database Schema

### Phase 1: Single Vehicle
```sql
CREATE TABLE fuel_entries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date INTEGER NOT NULL,           -- stored as Unix timestamp
  odometer_reading REAL NOT NULL,
  fuel_volume REAL NOT NULL,
  price_per_unit REAL NOT NULL,
  total_cost REAL NOT NULL,
  location TEXT
);
```

### Phase 2: Multi-Vehicle Support
```sql
-- New table for vehicles
CREATE TABLE vehicles (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  make TEXT,
  model TEXT,
  year TEXT
);

-- Modified fuel_entries table
ALTER TABLE fuel_entries 
ADD COLUMN vehicle_id INTEGER REFERENCES vehicles(id) ON DELETE CASCADE;

-- Index for quick lookups by vehicle
CREATE INDEX idx_fuel_entries_vehicle 
  ON fuel_entries(vehicle_id);
```