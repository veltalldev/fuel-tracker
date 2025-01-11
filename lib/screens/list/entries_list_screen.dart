import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EntriesListScreen extends ConsumerWidget {
  const EntriesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implement list view with FAB for new entries
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Entries'),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to entry form
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
