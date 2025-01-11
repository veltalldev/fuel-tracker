# Error Handling and Validation

## Implementation Strategy

### State Management
```dart
class FuelEntriesState {
  final List<FuelEntry> entries;
  final bool isLoading;
  final String? error;
}
```

### Error Handling Flow
1. UI Layer shows loading state
2. Operation attempted
3. Success: Update state and UI
4. Error: Display error message
5. Allow retry where appropriate

## Database Errors
- Wrap SQLite operations in try-catch blocks
- Error messages propagated to UI
- Loading states during operations
- Proper cleanup on errors
- Return Result<T> type for database operations
- Standard error types:
  ```dart
  sealed class DatabaseError {
    case ConnectionError();
    case NotFoundError();
    case ValidationError(String message);
    case UnknownError(Object error);
  }
  ```

## User Input Validation

### Phase 1 Validation
- Required fields: odometer, volume, price
- Business rules:
  - Odometer must increase over time
  - Volume and price must be positive
  - Date cannot be in future
- Show validation errors inline under fields

### Phase 2 Additional Validation
- Vehicle selection required for fuel entries
- Vehicle name required
- Prevent vehicle deletion with existing entries
  (or implement cascade delete)

### Validation Timing
- On form submission
- Real-time for numeric fields
- Before database operations

## Error Messages
Standard error messages for:
- Database errors
- Invalid input
- Version conflicts
- Permission denied

## Error Handling Strategy
1. Validate input before database operations
2. Use Result type for all repository operations
3. Display user-friendly error messages
4. Log technical errors for debugging
5. Implement proper error recovery where possible

## Recovery Mechanisms
- Retry failed operations
- Form data preservation
- State recovery on error
- Proper error boundaries