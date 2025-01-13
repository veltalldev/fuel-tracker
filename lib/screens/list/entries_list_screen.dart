import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_tracker/models/fuel_entry.dart';
import '../../repositories/providers/fuel_entries_provider.dart';
import 'components/entry_card.dart';
import 'components/month_header.dart';
import '../add/add_entry_screen.dart';
import 'components/stats_section.dart';
import 'components/collapsible_stats_section.dart';
import 'package:collection/collection.dart';
import 'components/efficiency_chart.dart';

class EntriesListScreen extends ConsumerStatefulWidget {
  const EntriesListScreen({super.key});

  @override
  ConsumerState<EntriesListScreen> createState() => _EntriesListScreenState();
}

class _EntriesListScreenState extends ConsumerState<EntriesListScreen> {
  bool _showDivider = false;

  Map<DateTime, List<FuelEntry>> groupEntriesByMonth(List<FuelEntry> entries) {
    return groupBy(
      entries,
      (entry) => DateTime(entry.date.year, entry.date.month),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              const CollapsibleStatsSection(
                child: StatsSection(),
              ),
              if (entriesState.entries.length >= 2)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: EfficiencyChart(entries: entriesState.entries),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _showDivider ? 1.0 : 0.0,
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(80),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "Fill History",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withAlpha(80),
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(80),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: entriesState.entries.isEmpty
                    ? const Center(child: Text('No entries yet'))
                    : NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification is ScrollUpdateNotification) {
                            setState(() {
                              _showDivider = notification.metrics.pixels > 20;
                            });
                          }
                          return true;
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                            left: 4,
                            right: 4,
                            bottom: 80,
                            top: 8,
                          ),
                          itemCount: groupedEntries.entries.length,
                          itemBuilder: (context, index) {
                            final entry =
                                groupedEntries.entries.elementAt(index);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MonthHeader(date: entry.key),
                                ...entry.value.map(
                                  (fuelEntry) => EntryCard(
                                    entry: fuelEntry,
                                    onTap: () => _editEntry(context, fuelEntry),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
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
