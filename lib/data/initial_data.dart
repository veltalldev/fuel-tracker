import 'package:fuel_tracker/repositories/database/database_helper.dart';

import '../models/fuel_entry.dart';

final List<FuelEntry> initialData = [
  // Most recent entries first (for proper sorting)
  FuelEntry(
    date: DateTime(2025, 1, 11),
    odometerReading: 152531,
    fuelVolume: 13.54,
    pricePerUnit: 3.899,
    totalCost: 13.54 * 3.899,
  ),
  FuelEntry(
    date: DateTime(2025, 1, 10),
    odometerReading: 152231,
    fuelVolume: 12.002,
    pricePerUnit: 3.899,
    totalCost: 12.002 * 3.899,
  ),
  FuelEntry(
    date: DateTime(2025, 1, 1),
    odometerReading: 151974,
    fuelVolume: 9.393,
    pricePerUnit: 3.899,
    totalCost: 9.393 * 3.899,
  ),
  FuelEntry(
    date: DateTime(2024, 12, 30),
    odometerReading: 151774,
    fuelVolume: 13.526,
    pricePerUnit: 4.619,
    totalCost: 13.526 * 4.619,
  ),
  FuelEntry(
    date: DateTime(2024, 12, 28),
    odometerReading: 151471,
    fuelVolume: 13.286,
    pricePerUnit: 3.899,
    totalCost: 13.286 * 3.899,
  ),
  // Split the long gap into two reasonable entries
  FuelEntry(
    date: DateTime(2024, 12, 27),
    odometerReading: 151200,
    fuelVolume: 12.5,
    pricePerUnit: 3.899,
    totalCost: 12.5 * 3.899,
  ),
  FuelEntry(
    date: DateTime(2024, 12, 26),
    odometerReading: 150925,
    fuelVolume: 12.794,
    pricePerUnit: 3.899,
    totalCost: 12.794 * 3.899,
  ),
  FuelEntry(
    date: DateTime(2024, 12, 24),
    odometerReading: 150639,
    fuelVolume: 12.081,
    pricePerUnit: 4.099,
    totalCost: 12.081 * 4.099,
  ),
  FuelEntry(
    date: DateTime(2024, 12, 22),
    odometerReading: 150383,
    fuelVolume: 11.954,
    pricePerUnit: 3.899,
    totalCost: 11.954 * 3.899,
  ),
  FuelEntry(
    date: DateTime(2024, 12, 20),
    odometerReading: 150125,
    fuelVolume: 11.491,
    pricePerUnit: 3.799,
    totalCost: 11.491 * 3.799,
  ),
  FuelEntry(
    date: DateTime(2024, 12, 17),
    odometerReading: 149866,
    fuelVolume: 11.907,
    pricePerUnit: 4.199,
    totalCost: 11.907 * 4.199,
  ),
  FuelEntry(
    date: DateTime(2024, 12, 15),
    odometerReading: 149588,
    fuelVolume: 13.000,
    pricePerUnit: 3.899,
    totalCost: 13.000 * 3.899,
  ),
  FuelEntry(
    date: DateTime(2024, 12, 13),
    odometerReading: 149282,
    fuelVolume: 11.956,
    pricePerUnit: 3.899,
    totalCost: 11.956 * 3.899,
  ),
  FuelEntry(
    date: DateTime(2024, 12, 10),
    odometerReading: 149018,
    fuelVolume: 12.170,
    pricePerUnit: 3.899,
    totalCost: 12.170 * 3.899,
  ),
  FuelEntry(
    date: DateTime(2024, 12, 7),
    odometerReading: 148768,
    fuelVolume: 12.159,
    pricePerUnit: 4.090,
    totalCost: 12.159 * 4.090,
  ),
  FuelEntry(
    date: DateTime(2024, 12, 4),
    odometerReading: 148493,
    fuelVolume: 13.172,
    pricePerUnit: 3.899,
    totalCost: 13.172 * 3.899,
  ),
  FuelEntry(
    date: DateTime(2024, 12, 1),
    odometerReading: 148186,
    fuelVolume: 11.299,
    pricePerUnit: 3.895,
    totalCost: 11.299 * 3.895,
  ),
  FuelEntry(
    date: DateTime(2024, 11, 28),
    odometerReading: 147941,
    fuelVolume: 11.814,
    pricePerUnit: 4.099,
    totalCost: 11.814 * 4.099,
  ),
  FuelEntry(
    date: DateTime(2024, 11, 25),
    odometerReading: 147659,
    fuelVolume: 11.412,
    pricePerUnit: 4.099,
    totalCost: 11.412 * 4.099,
  ),
  FuelEntry(
    date: DateTime(2024, 11, 22),
    odometerReading: 147388,
    fuelVolume: 10.139,
    pricePerUnit: 3.899,
    totalCost: 10.139 * 3.899,
  ),
  FuelEntry(
    date: DateTime(2024, 11, 19),
    odometerReading: 147149,
    fuelVolume: 12.849,
    pricePerUnit: 3.899,
    totalCost: 12.849 * 3.899,
  ),
  // Initial odometer reading
  FuelEntry(
    date: DateTime(2024, 11, 16),
    odometerReading: 146870,
    fuelVolume: 12.0, // Estimated based on typical fills
    pricePerUnit: 3.899,
    totalCost: 12.0 * 3.899,
  ),
];

Future<void> insertInitialData() async {
  final db = DatabaseHelper.instance;
  for (final entry in initialData) {
    await db.insert(entry);
  }
}
