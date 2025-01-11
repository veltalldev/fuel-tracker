import '../../../utils/constants.dart';

const String createFuelEntriesTable = '''
  CREATE TABLE $tableFuelEntries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date INTEGER NOT NULL,
    odometer_reading REAL NOT NULL,
    fuel_volume REAL NOT NULL,
    price_per_unit REAL NOT NULL,
    total_cost REAL NOT NULL,
    location TEXT,
    miles_per_gallon REAL
  )
''';

const List<String> initialMigrations = [
  createFuelEntriesTable,
];
