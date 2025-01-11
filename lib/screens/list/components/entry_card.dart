import 'package:flutter/material.dart';
import '../../../models/fuel_entry.dart';

class EntryCard extends StatelessWidget {
  final FuelEntry entry;
  final VoidCallback? onTap;

  const EntryCard({
    super.key,
    required this.entry,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement entry card UI
    return Card();
  }
}
