import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/providers/fuel_entries_provider.dart';
import '../../widgets/common/error_display.dart';
import '../../widgets/common/loading_indicator.dart';
import '../entry/fuel_entry_form.dart';
import 'components/entry_card.dart';

class EntriesListScreen extends ConsumerWidget {
  const EntriesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesState = ref.watch(fuelEntriesProvider);

    // Show loading indicator while data is being fetched
    if (entriesState.isLoading) {
      return const Scaffold(
        body: LoadingIndicator(),
      );
    }

    // Show error if something went wrong
    if (entriesState.error != null) {
      return Scaffold(
        body: ErrorDisplay(
          message: entriesState.error!,
          onRetry: () =>
              ref.refresh(fuelEntriesProvider.notifier).loadEntries(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Entries'),
        // TODO: Add statistics button in Phase 1.5
      ),
      body: entriesState.entries.isEmpty
          ? const Center(
              child: Text('No entries yet. Tap + to add one!'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: entriesState.entries.length,
              itemBuilder: (context, index) {
                final entry = entriesState.entries[index];
                return EntryCard(
                  entry: entry,
                  onTap: () => _editEntry(context, entry),
                  onDismissed: (direction) =>
                      _deleteEntry(context, ref, entry.id!),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEntry(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addEntry(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FuelEntryForm(),
      ),
    );
  }

  void _editEntry(BuildContext context, entry) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FuelEntryForm(entry: entry),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, WidgetRef ref, int id) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await ref.read(fuelEntriesProvider.notifier).deleteEntry(id);

      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Entry deleted'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Failed to delete entry: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
