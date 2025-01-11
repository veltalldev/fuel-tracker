# Fuel Tracker App Documentation

## Project Overview
A Flutter application for tracking vehicle fuel consumption with:
- Single vehicle fuel consumption tracking (Phase 1)
- Local SQLite storage
- Material 3 design system
- Basic statistics and cost analysis

## Project Conventions

### Folder Structure
```
lib/
├── models/           # Data models
│   └── fuel_entry.dart
├── repositories/     # Data access layer
│   ├── database/    # Database operations
│   └── providers/   # Riverpod providers
├── screens/         # UI screens
├── widgets/         # Reusable widgets
└── utils/          # Helper functions

test/               # Unit and widget tests

docs/               # Project documentation
├── project/        # Project-level documentation
│   ├── structure.md          # Project Structure and Conventions
│   ├── tech-stack.md         # Technical Stack and Architecture
│   └── error-handling.md     # Error Handling and Validation
├── features/       # Feature documentation
│   └── screens.md            # Features and Screen Flow
├── development/    # Development documentation
│   ├── phases.md             # Development Phases
│   └── progress.md           # Progress Tracker
└── README.md       # Documentation overview and index
```

### Code Style Guidelines
- Use final for immutable variables
- Implement copyWith() for all models
- Include fromJson/toJson for all models
- Document public APIs with /// comments
- Prefix providers with ref.watch/ref.read

### Naming Conventions
- Files: snake_case (e.g., fuel_entry.dart)
- Classes: PascalCase (e.g., FuelEntry)
- Variables/methods: camelCase (e.g., fuelVolume)
- Database tables: snake_case (e.g., fuel_entries)
- Providers: {feature}Provider (e.g., fuelEntriesProvider)

## Implementation Details

### Models
- `FuelEntry` - Core data model for fuel purchase records
  - Required: date, odometer reading, fuel volume, price per unit, total cost
  - Optional: location, miles per gallon
  - Includes JSON serialization and copyWith functionality

### Theming
- Material 3 design system
- Light/dark theme support
- Consistent input decoration
- Color scheme based on blue seed color

## Current Status

### Phase 1 Features
- [x] View fuel entries list
- [x] Add new fuel entries
- [x] Edit existing entries
- [x] Delete entries (with swipe gesture)
- [x] Basic error handling
- [x] Loading states
- [x] Sample data generation
- [ ] Form validation (structure ready, needs implementation)
- [ ] Statistics display
- [ ] Location support (UI ready, needs implementation)

### Next Steps
1. Complete form validation implementation
2. Add statistics display
3. Implement location support
4. Polish UI and user experience
5. Prepare for Phase 2 features