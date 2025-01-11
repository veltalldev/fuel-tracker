import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/initial_data.dart';
import 'repositories/database/database_helper.dart';
import 'screens/list/entries_list_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database and insert initial data
  final db = DatabaseHelper.instance;
  final hasData = await db.hasAnyEntries();
  if (!hasData) {
    await insertInitialData();
  }

  runApp(
    const ProviderScope(
      child: FuelTrackerApp(),
    ),
  );
}

class FuelTrackerApp extends StatelessWidget {
  const FuelTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuel Tracker',
      theme: AppTheme.darkTheme,
      home: const EntriesListScreen(),
    );
  }
}
