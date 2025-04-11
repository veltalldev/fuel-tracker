import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/fuel_entry.dart';

class EfficiencyChart extends StatelessWidget {
  final List<FuelEntry> entries;
  final int maxEntries;

  const EfficiencyChart({
    super.key,
    required this.entries,
    this.maxEntries = 10,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (entries.length < 2) return const SizedBox.shrink();

    // Sort entries by date, oldest first
    final sortedEntries = List<FuelEntry>.from(entries)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Calculate cumulative efficiency at each point
    final efficiencyPoints = <FlSpot>[];
    for (int i = 1; i < sortedEntries.length; i++) {
      // Total distance from start to this point
      final totalDistance =
          sortedEntries[i].odometerReading - sortedEntries[0].odometerReading;

      // Sum of all fuel volumes up to previous entry
      final totalVolume = sortedEntries
          .sublist(0, i)
          .fold<double>(0, (sum, e) => sum + e.fuelVolume);

      // Cumulative efficiency at this point
      final efficiency = totalDistance / totalVolume;
      efficiencyPoints.add(FlSpot(i.toDouble(), efficiency));
    }

    // Take only the last maxEntries points
    final displayPoints = efficiencyPoints.length > maxEntries
        ? efficiencyPoints.sublist(efficiencyPoints.length - maxEntries)
        : efficiencyPoints;

    // Calculate bounds with some padding
    final minY = displayPoints.map((p) => p.y).reduce(min);
    final maxY = displayPoints.map((p) => p.y).reduce(max);
    final range = maxY - minY;
    final padding = range * 0.1; // 10% padding
    final interval =
        range > 0 ? range / 1.3 : 1.0; // Ensure non-zero interval with fallback

    // Round to nearest 0.5 to avoid awkward label placement
    final roundedMinY = (minY - padding - 0.25).roundToDouble() * 2 / 2;
    final roundedMaxY = (maxY + padding + 0.25).roundToDouble() * 2 / 2;

    return Card(
      margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Efficiency Trend (mi/gal)',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(200),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: interval,
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: interval,
                        getTitlesWidget: (value, meta) => Text(
                          value.toStringAsFixed(1),
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      curveSmoothness: 0.5,
                      spots: displayPoints,
                      isCurved: true,
                      color: theme.colorScheme.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            theme.colorScheme.primary.withAlpha(120),
                            theme.colorScheme.primary.withAlpha(0),
                          ],
                        ),
                      ),
                    ),
                  ],
                  minY: roundedMinY,
                  maxY: roundedMaxY,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last ${displayPoints.length} fill-ups',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(122),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
