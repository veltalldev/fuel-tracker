import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../models/fuel_entry.dart';
import '../../../repositories/providers/fuel_entries_provider.dart';

class StatsSection extends ConsumerWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final entriesState = ref.watch(fuelEntriesProvider);
    final entries = entriesState.entries;

    if (entries.isEmpty) return const SizedBox.shrink();

    // Calculate metrics
    final lastEntry = entries.reduce((a, b) => a.date.isAfter(b.date) ? a : b);

    // Find second-to-last entry
    final secondLastEntry = entries
        .where((e) => e.date.isBefore(lastEntry.date))
        .reduce((a, b) => a.date.isAfter(b.date) ? a : b);

    // Calculate last trip distance
    final lastTripDistance =
        lastEntry.odometerReading - secondLastEntry.odometerReading;

    // Monthly spending
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month);
    final monthlyEntries = entries
        .where((e) =>
            e.date.isAfter(monthStart) ||
            (e.date.year == monthStart.year &&
                e.date.month == monthStart.month))
        .toList();
    final monthlySpent = monthlyEntries.fold<double>(
        0, (sum, e) => sum + (e.fuelVolume * e.pricePerUnit));
    final monthlyVolume =
        monthlyEntries.fold<double>(0, (sum, e) => sum + e.fuelVolume);

    // Efficiency calculations
    double? efficiency;
    if (entries.length >= 2) {
      // Sort entries by date, oldest first
      final sortedEntries = List<FuelEntry>.from(entries)
        ..sort((a, b) => a.date.compareTo(b.date));

      // Calculate total distance and volume
      final totalDistance = sortedEntries.last.odometerReading -
          sortedEntries.first.odometerReading;
      final totalVolume = sortedEntries
          .sublist(0, sortedEntries.length - 1)
          .fold<double>(0, (sum, e) => sum + e.fuelVolume);

      efficiency = totalDistance / totalVolume;
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last Fill-up',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          NumberFormat.currency(symbol: '\$').format(
                              lastEntry.fuelVolume * lastEntry.pricePerUnit),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                          ),
                        ),
                        Text(
                          '${lastEntry.fuelVolume.toStringAsFixed(1)} gal × \$${lastEntry.pricePerUnit.toStringAsFixed(2)}/gal',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monthly Spent',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          NumberFormat.currency(symbol: '\$')
                              .format(monthlySpent),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                          ),
                        ),
                        Text(
                          '${monthlyVolume.toStringAsFixed(1)} gallons total',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last Trip',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        if (entries.length >= 2) ...[
                          Text(
                            '${lastTripDistance.toStringAsFixed(0)} mi',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontFamily:
                                  GoogleFonts.jetBrainsMono().fontFamily,
                            ),
                          ),
                          Text(
                            'Distance between fills',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overall Efficiency',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          '${efficiency?.toStringAsFixed(1) ?? '--'} mpg',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                          ),
                        ),
                        Text(
                          'All-time average',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
