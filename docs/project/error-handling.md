# Error Handling and Validation

## Database Errors
- Wrap SQLite operations in try-catch blocks
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