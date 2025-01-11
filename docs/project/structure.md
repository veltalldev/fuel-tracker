# Fuel Tracker App Documentation

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

### Naming Conventions
- Files: snake_case (e.g., fuel_entry.dart)
- Classes: PascalCase (e.g., FuelEntry)
- Variables/methods: camelCase (e.g., fuelVolume)
- Database tables: snake_case (e.g., fuel_entries)
- Providers: {feature}Provider (e.g., fuelEntriesProvider)

### Code Style Guidelines
- Use final for immutable variables
- Implement copyWith() for all models
- Include fromJson/toJson for all models
- Document public APIs with /// comments
- Prefix providers with ref.watch/ref.read