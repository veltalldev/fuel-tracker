import 'package:flutter/foundation.dart';

@immutable
class FuelEntry {
  final int? id;
  final DateTime date;
  final double odometerReading;
  final double fuelVolume;
  final double pricePerUnit;
  final double totalCost;
  final String? location;
  final double? milesPerGallon;

  const FuelEntry({
    this.id,
    required this.date,
    required this.odometerReading,
    required this.fuelVolume,
    required this.pricePerUnit,
    required this.totalCost,
    this.location,
    this.milesPerGallon,
  });

  // Create a copy of this FuelEntry with optional new values
  FuelEntry copyWith({
    int? id,
    DateTime? date,
    double? odometerReading,
    double? fuelVolume,
    double? pricePerUnit,
    double? totalCost,
    String? location,
    double? milesPerGallon,
  }) {
    return FuelEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      odometerReading: odometerReading ?? this.odometerReading,
      fuelVolume: fuelVolume ?? this.fuelVolume,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      totalCost: totalCost ?? this.totalCost,
      location: location ?? this.location,
      milesPerGallon: milesPerGallon ?? this.milesPerGallon,
    );
  }

  // Convert a FuelEntry instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'odometer_reading': odometerReading,
      'fuel_volume': fuelVolume,
      'price_per_unit': pricePerUnit,
      'total_cost': totalCost,
      'location': location,
      'miles_per_gallon': milesPerGallon,
    };
  }

  // Create a FuelEntry instance from a Map
  factory FuelEntry.fromJson(Map<String, dynamic> json) {
    return FuelEntry(
      id: json['id'] as int?,
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      odometerReading: json['odometer_reading'] as double,
      fuelVolume: json['fuel_volume'] as double,
      pricePerUnit: json['price_per_unit'] as double,
      totalCost: json['total_cost'] as double,
      location: json['location'] as String?,
      milesPerGallon: json['miles_per_gallon'] as double?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FuelEntry &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          date == other.date &&
          odometerReading == other.odometerReading &&
          fuelVolume == other.fuelVolume &&
          pricePerUnit == other.pricePerUnit &&
          totalCost == other.totalCost &&
          location == other.location &&
          milesPerGallon == other.milesPerGallon;

  @override
  int get hashCode =>
      id.hashCode ^
      date.hashCode ^
      odometerReading.hashCode ^
      fuelVolume.hashCode ^
      pricePerUnit.hashCode ^
      totalCost.hashCode ^
      location.hashCode ^
      milesPerGallon.hashCode;

  @override
  String toString() {
    return 'FuelEntry(id: $id, date: $date, odometerReading: $odometerReading, '
        'fuelVolume: $fuelVolume, pricePerUnit: $pricePerUnit, '
        'totalCost: $totalCost, location: $location, milesPerGallon: $milesPerGallon)';
  }
}
