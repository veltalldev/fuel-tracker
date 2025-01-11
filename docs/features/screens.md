# Features and Screen Flow

## Current Implementation (Phase 1)

### Main List Screen
- List of fuel entries sorted by date
- Empty state message when no entries
- Swipe-to-delete functionality
- Tap to edit entries
- FAB for adding new entries
- Loading and error states

### Entry Form Screen
- Add/Edit fuel entries
- Form fields:
  - Date (date picker, defaults to current)
  - Odometer Reading (numeric input)
  - Fuel Volume (numeric input)
  - Price per Unit (numeric input)
  - Location (optional text input)
- Auto-calculated fields:
  - Total Cost (volume × price)
  - MPG (calculated from previous entry)
- Loading state during operations
- Validation feedback
- Success/error messages via Snackbar

## UI Components

### EntryCard
- Date and total cost header
- Odometer reading display
- Fuel volume display
- Price per unit display
- MPG display (when available)
- Location display (when available)
- Swipe-to-delete gesture
- Material 3 design styling

### Common Widgets
- ErrorDisplay
  - Error icon
  - Error message
  - Optional retry button
- LoadingIndicator
  - Centered progress indicator
  - Consistent styling

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