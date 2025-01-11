import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/fuel_entry.dart';
import '../../utils/validators.dart';
import '../database/database_helper.dart';

// Provider for the DatabaseHelper instance
final databaseProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

// State class for fuel entries
class FuelEntriesState {
  final List<FuelEntry> entries;
  final bool isLoading;
  final String? error;

  const FuelEntriesState({
    this.entries = const [],
    this.isLoading = false,
    this.error,
  });

  FuelEntriesState copyWith({
    List<FuelEntry>? entries,
    bool? isLoading,
    String? error,
  }) {
    return FuelEntriesState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// NotifierProvider for fuel entries
class FuelEntriesNotifier extends StateNotifier<FuelEntriesState> {
  final DatabaseHelper _db;

  FuelEntriesNotifier(this._db) : super(const FuelEntriesState()) {
    // Load entries when the provider is initialized
    loadEntries();
  }

  Future<void> loadEntries() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final entries = await _db.getAllFuelEntries();

      // Sort entries by date, newest first
      entries.sort((a, b) => b.date.compareTo(a.date));

      state = state.copyWith(
        entries: entries,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load entries: $e',
      );
    }
  }

  Future<double?> getPreviousOdometerReading(DateTime entryDate) async {
    try {
      // Get the reading from the most recent entry BEFORE the given date
      final entries = state.entries
          .where((e) => e.date.isBefore(entryDate))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      return entries.isNotEmpty ? entries.first.odometerReading : null;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to get previous odometer reading: $e',
      );
      return null;
    }
  }

  Future<bool> validateEntry(FuelEntry entry) async {
    try {
      final previousReading = await getPreviousOdometerReading(entry.date);

      // Create validators
      final odometerValidator =
          OdometerValidator(previousReading: previousReading);

      // Validate all fields
      final odometerError =
          odometerValidator.validate(entry.odometerReading.toString());
      final volumeError = volumeValidator.validate(entry.fuelVolume.toString());
      final priceError = priceValidator.validate(entry.pricePerUnit.toString());
      final dateError = dateValidator.validate(entry.date);

      // Collect all validation errors
      final errors = <String>[];
      if (odometerError != null) errors.add(odometerError);
      if (volumeError != null) errors.add(volumeError);
      if (priceError != null) errors.add(priceError);
      if (dateError != null) errors.add(dateError);

      // Update state if there are errors
      if (errors.isNotEmpty) {
        state = state.copyWith(
          error: errors.join('\n'),
          isLoading: false,
        );
        return false;
      }

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Validation error: $e',
        isLoading: false,
      );
      return false;
    }
  }

  Future<void> addEntry(FuelEntry entry) async {
    try {
      // Validate first, before changing state
      if (!await validateEntry(entry)) {
        return;
      }

      state = state.copyWith(isLoading: true, error: null);

      // Use the last reading we already have from validation
      final lastReading = await getPreviousOdometerReading(entry.date);

      // Calculate MPG
      final mpg = lastReading != null
          ? (entry.odometerReading - lastReading) / entry.fuelVolume
          : null;

      // Create new entry with calculated MPG
      final newEntry = entry.copyWith(milesPerGallon: mpg);

      // Insert into database
      final savedEntry = await _db.insert(newEntry);

      // Update state with new entry
      state = state.copyWith(
        entries: [savedEntry, ...state.entries],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to add entry: $e',
      );
    }
  }

  Future<void> updateEntry(FuelEntry entry) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Update in database
      await _db.update(entry);

      // Update state
      final updatedEntries = state.entries.map((e) {
        return e.id == entry.id ? entry : e;
      }).toList();

      state = state.copyWith(
        entries: updatedEntries,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update entry: $e',
      );
    }
  }

  Future<void> deleteEntry(int id) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Delete from database
      await _db.delete(id);

      // Update state
      final updatedEntries = state.entries.where((e) => e.id != id).toList();

      state = state.copyWith(
        entries: updatedEntries,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to delete entry: $e',
      );
    }
  }
}

// Provider for fuel entries state
final fuelEntriesProvider =
    StateNotifierProvider<FuelEntriesNotifier, FuelEntriesState>((ref) {
  final db = ref.watch(databaseProvider);
  return FuelEntriesNotifier(db);
});

// Convenience providers for derived state
final entriesListProvider = Provider<List<FuelEntry>>((ref) {
  return ref.watch(fuelEntriesProvider).entries;
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(fuelEntriesProvider).isLoading;
});

final errorProvider = Provider<String?>((ref) {
  return ref.watch(fuelEntriesProvider).error;
});
