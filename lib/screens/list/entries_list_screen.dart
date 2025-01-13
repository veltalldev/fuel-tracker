import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_tracker/models/fuel_entry.dart';
import '../../repositories/providers/fuel_entries_provider.dart';
import '../entry/fuel_entry_form.dart';
import 'components/entry_card.dart';
import 'components/month_header.dart';
import '../add/add_entry_screen.dart';
import 'components/stats_section.dart';
import 'package:collection/collection.dart';

class EntriesListScreen extends ConsumerWidget {
  const EntriesListScreen({super.key});

  Map<DateTime, List<FuelEntry>> groupEntriesByMonth(List<FuelEntry> entries) {
    return groupBy(
      entries,
      (entry) => DateTime(entry.date.year, entry.date.month),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Tracker'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final entriesState = ref.watch(fuelEntriesProvider);

          if (entriesState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (entriesState.error != null) {
            return Center(child: Text(entriesState.error!));
          }

          final groupedEntries = groupEntriesByMonth(entriesState.entries);

          return Column(
            children: [
              const StatsSection(),
              Expanded(
                child: entriesState.entries.isEmpty
                    ? const Center(child: Text('No entries yet'))
                    : ListView.builder(
                        padding: const EdgeInsets.only(
                          left: 4,
                          right: 4,
                          bottom: 80,
                          top: 8,
                        ),
                        itemCount: groupedEntries.entries.fold<int>(
                          0,
                          (sum, entry) =>
                              sum +
                              entry.value.length +
                              1, // +1 for each header
                        ),
                        itemBuilder: (context, index) {
                          // Find which group this index belongs to
                          int runningIndex = 0;
                          for (final monthEntry in groupedEntries.entries) {
                            if (index == runningIndex) {
                              // This is a header
                              return MonthHeader(date: monthEntry.key);
                            }
                            if (index <
                                runningIndex + monthEntry.value.length + 1) {
                              // This is an entry in the current month
                              final entry =
                                  monthEntry.value[index - runningIndex - 1];
                              return EntryCard(
                                entry: entry,
                                onTap: () => _editEntry(context, entry),
                                onDismissed: (direction) => entry.id != null
                                    ? _deleteEntry(context, ref, entry.id!)
                                    : null,
                              );
                            }
                            runningIndex += monthEntry.value.length + 1;
                          }
                          return null;
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEntry(context),
        elevation: 4,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add_rounded,
          size: 24,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _addEntry(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddEntryScreen(),
      ),
    );
  }

  void _editEntry(BuildContext context, entry) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEntryScreen(entry: entry),
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
