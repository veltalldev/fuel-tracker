# Features and Screen Flow

## Current Implementation (Phase 1)

### Main List Screen
- List of fuel entries sorted by date
- Entries grouped by month with headers
- Empty state message when no entries
- Swipe-to-delete functionality
- Tap to edit entries
- FAB for adding new entries
- Loading and error states

### Entry Form Screen
- Material 3 design with card groups
- Add/Edit fuel entries
- Form groups:
  1. Basic Information
     - Date (date picker, defaults to current)
     - Odometer Reading (numeric input)
  2. Fuel Details
     - Fuel Volume (numeric input)
     - Price per Unit (numeric input)
     - Real-time total calculation
  3. Additional Information
     - Location (optional text input)
- Enhanced validation:
  - Previous odometer validation
  - Numeric field validation
  - Date validation
  - Real-time feedback
- Loading state during operations
- Success/error messages via Snackbar

### UI Components
- FormGroupCard
  - Semi-transparent background
  - Consistent padding
  - Group title styling
- LabeledTextField
  - Label and icon styling
  - Unit suffix support
  - Validation integration
- EntryCard
  - Date and total cost header
  - Odometer reading display
  - Fuel volume display
  - Price per unit display
  - MPG display (when available)
  - Location display (when available)
  - Swipe-to-delete gesture
  - Material 3 design styling

## Planned Features (Phase 1.5)
- Statistics button in app bar
- Basic statistics display
  - Average MPG
  - Total spent
  - Total volume
- Enhanced validation
- Location autocomplete

## Future Features (Phase 2)
- Vehicle management
  - Add/edit/delete vehicles
  - Vehicle selection in entries
  - Per-vehicle statistics
- Data export
- Backup/restore
- Enhanced statistics