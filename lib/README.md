# Fuel Tracker App - Source Code

## Directory Structure 

```
lib/
├── models/ # Data models and DTOs
│ └── fuel_entry.dart
│
├── repositories/ # Data access and state management
│ ├── database/ # SQLite database operations
│ │ ├── database_helper.dart
│ │ └── migrations/
│ │ └── initial_schema.dart
│ └── providers/ # Riverpod state providers
│ └── fuel_entries_provider.dart
│
├── screens/ # UI screens and their components
│ ├── entry/ # Fuel entry form
│ │ └── fuel_entry_form.dart
│ └── list/ # Main list view
│ ├── components/
│ │ └── entry_card.dart
│ └── entries_list_screen.dart
│
├── widgets/ # Reusable widgets
│ └── common/ # App-wide common widgets
│ ├── error_display.dart
│ └── loading_indicator.dart
│
├── utils/ # Helper functions and constants
│ └── constants.dart
│
├── README.md # This file
└── main.dart # Application entry point
```

## Architecture

This app follows a simple three-layer architecture:
1. **UI Layer** (`screens/`, `widgets/`) - Presentation logic
2. **State Layer** (`repositories/providers/`) - State management using Riverpod
3. **Data Layer** (`repositories/database/`, `models/`) - Data operations and models

## Key Components

### Models
- `FuelEntry` - Core data model for fuel purchase records

### Repositories
- `DatabaseHelper` - SQLite database operations
- `FuelEntriesProvider` - State management for fuel entries

### Screens
- `EntriesListScreen` - Main view showing all entries
- `FuelEntryForm` - Form for adding/editing entries

### Common Widgets
- `ErrorDisplay` - Consistent error message display
- `LoadingIndicator` - Loading state indicator

## Conventions

### File Naming
- All files use `snake_case.dart`
- Components are named in `PascalCase`
- Screen files are suffixed with `_screen`
- Form files are suffixed with `_form`

### State Management
- Use Riverpod providers for state
- Keep providers in `repositories/providers/`
- Separate business logic from UI

### Widget Structure
- Stateless widgets preferred when possible
- Break complex widgets into smaller components
- Keep widget files focused and single-purpose

### Database Operations
- All database access through `DatabaseHelper`
- Migrations in `migrations/` directory
- Use constants from `constants.dart`

## Phase 1 Features
- [x] View fuel entries list
- [x] Add new fuel entries
- [x] Edit existing entries
- [x] Delete entries
- [x] Basic error handling
- [x] Loading states
- [ ] Statistics display
- [ ] Data validation
- [ ] Location support

## Future Enhancements (Phase 2)
- [ ] Multiple vehicle support
- [ ] Enhanced statistics
- [ ] Data export
- [ ] Backup/restore