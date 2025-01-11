import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/fuel_entry.dart';
import '../../utils/constants.dart';
import 'migrations/initial_schema.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    for (final migration in initialMigrations) {
      await db.execute(migration);
    }
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // TODO: Implement database upgrades for future versions
  }

  // CRUD Operations

  Future<FuelEntry> insert(FuelEntry entry) async {
    final db = await database;
    final id = await db.insert(
      tableFuelEntries,
      entry.toJson()..remove('id'), // Remove id for auto-increment
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return entry.copyWith(id: id);
  }

  Future<FuelEntry?> getFuelEntry(int id) async {
    final db = await database;
    final maps = await db.query(
      tableFuelEntries,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return FuelEntry.fromJson(maps.first);
  }

  Future<List<FuelEntry>> getAllFuelEntries() async {
    final db = await database;
    final result = await db.query(
      tableFuelEntries,
      orderBy: 'date DESC',
    );

    return result.map((json) => FuelEntry.fromJson(json)).toList();
  }

  Future<int> update(FuelEntry entry) async {
    final db = await database;
    return db.update(
      tableFuelEntries,
      entry.toJson(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      tableFuelEntries,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllEntries() async {
    final db = await database;
    await db.delete(tableFuelEntries);
  }

  // Additional utility methods

  Future<double?> getLastOdometerReading() async {
    final db = await database;
    final result = await db.query(
      tableFuelEntries,
      columns: ['odometer_reading'],
      orderBy: 'date DESC',
      limit: 1,
    );

    if (result.isEmpty) return null;
    return result.first['odometer_reading'] as double;
  }

  Future<double?> calculateMPG(double currentOdometer, double? previousOdometer,
      double fuelVolume) async {
    if (previousOdometer == null) return null;
    final distance = currentOdometer - previousOdometer;
    if (distance <= 0 || fuelVolume <= 0) return null;
    return distance / fuelVolume;
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }

  Future<void> insertSampleData() async {
    final sampleEntries = [
      FuelEntry(
        date: DateTime.now().subtract(const Duration(days: 30)),
        odometerReading: 45000,
        fuelVolume: 12.5,
        pricePerUnit: 3.49,
        totalCost: 43.63,
        location: 'Shell on Main St',
        milesPerGallon: 28.4,
      ),
      FuelEntry(
        date: DateTime.now().subtract(const Duration(days: 15)),
        odometerReading: 45350,
        fuelVolume: 11.8,
        pricePerUnit: 3.55,
        totalCost: 41.89,
        location: 'Costco Gas',
        milesPerGallon: 29.7,
      ),
      FuelEntry(
        date: DateTime.now().subtract(const Duration(days: 2)),
        odometerReading: 45680,
        fuelVolume: 12.2,
        pricePerUnit: 3.39,
        totalCost: 41.36,
        location: 'QuikTrip #123',
        milesPerGallon: 27.0,
      ),
    ];

    for (final entry in sampleEntries) {
      await insert(entry);
    }
  }

  Future<bool> hasAnyEntries() async {
    final db = await database;
    final result = await db.query(
      'fuel_entries',
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
