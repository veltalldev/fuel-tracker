# Technical Stack and Architecture

## Essential Dependencies
- flutter_riverpod: ^3.0.0 - State management
- sqflite: ^2.3.0 - Local database
- intl: ^0.19.0 - Date/number formatting

## Architecture
Three-layer architecture:
1. UI Layer (Screens & Widgets)
   - Material 3 design system
   - Responsive layouts
   - Error and loading states
2. State Layer (Riverpod Providers)
   - Centralized state management
   - CRUD operations
   - Error handling
3. Data Layer (SQLite & Models)
   - Local persistence
   - Data models
   - Database operations

## Data Models

```dart
// Phase 1: Single Vehicle Fuel Entry Model
class FuelEntry {
  final int? id;
  final DateTime date;
  final double odometerReading;
  final double fuelVolume;
  final double pricePerUnit;
  final double totalCost;
  final String? location;
  final double? milesPerGallon; // Calculated from previous entry
  // Includes:
  // - JSON serialization
  // - copyWith functionality
  // - equality comparison
  // - toString method
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
  date INTEGER NOT NULL, -- stored as millisecondsSinceEpoch
  odometer_reading REAL NOT NULL,
  fuel_volume REAL NOT NULL,
  price_per_unit REAL NOT NULL,
  total_cost REAL NOT NULL,
  location TEXT,
  miles_per_gallon REAL -- calculated field
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