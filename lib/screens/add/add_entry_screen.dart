import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_tracker/models/fuel_entry.dart';
import 'package:fuel_tracker/repositories/providers/fuel_entries_provider.dart';
import 'components/form_group_card.dart';
import 'components/labeled_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:fuel_tracker/utils/validators.dart';

class AddEntryScreen extends ConsumerStatefulWidget {
  final FuelEntry? entry;

  const AddEntryScreen({
    super.key,
    this.entry,
  });

  @override
  ConsumerState<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends ConsumerState<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _odometerController;
  late TextEditingController _volumeController;
  late TextEditingController _priceController;
  late TextEditingController _locationController;
  late DateTime _selectedDate;
  OdometerValidator? _odometerValidator;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.entry?.date ?? DateTime.now();
    _odometerController = TextEditingController(
      text: widget.entry?.odometerReading.toString(),
    );
    _volumeController = TextEditingController(
      text: widget.entry?.fuelVolume.toString(),
    )..addListener(_updateTotal);
    _priceController = TextEditingController(
      text: widget.entry?.pricePerUnit.toString(),
    )..addListener(_updateTotal);
    _locationController = TextEditingController(
      text: widget.entry?.location,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupValidators();
    });
  }

  Future<void> _setupValidators() async {
    if (!mounted) return;

    final previousReading = await ref
        .read(fuelEntriesProvider.notifier)
        .getPreviousOdometerReading(_selectedDate);

    setState(() {
      _odometerValidator = OdometerValidator(
        previousReading: previousReading,
      );
    });
  }

  @override
  void dispose() {
    _odometerController.dispose();
    _volumeController.removeListener(_updateTotal);
    _volumeController.dispose();
    _priceController.removeListener(_updateTotal);
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _updateTotal() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        toolbarHeight: 64,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.entry == null ? 'Add Entry' : 'Edit Entry',
          style: theme.textTheme.titleLarge,
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            FormGroupCard(
              title: 'Basic Information',
              children: [
                LabeledTextField(
                  label: 'Date',
                  icon: Icons.calendar_today,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => _selectedDate = date);
                      await _setupValidators();
                    }
                  },
                  readOnly: true,
                  controller: TextEditingController(
                    text: DateFormat('MMM d, y').format(_selectedDate),
                  ),
                  validator: (_) => dateValidator.validate(_selectedDate),
                ),
                LabeledTextField(
                  label: 'Odometer Reading',
                  icon: Icons.speed,
                  controller: _odometerController,
                  keyboardType: TextInputType.number,
                  suffix: 'mi',
                  validator: _odometerValidator?.validate,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ],
            ),
            const SizedBox(height: 24),
            FormGroupCard(
              title: 'Fuel Details',
              children: [
                LabeledTextField(
                  label: 'Fuel Volume',
                  icon: Icons.local_gas_station,
                  controller: _volumeController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  suffix: 'gal',
                  validator: volumeValidator.validate,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                ),
                LabeledTextField(
                  label: 'Price per Gallon',
                  icon: Icons.attach_money,
                  controller: _priceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  suffix: '\$/gal',
                  validator: priceValidator.validate,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                ),
                Divider(
                  height: 32,
                  color: Theme.of(context).dividerColor.withAlpha(122),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      _calculateTotal(),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            FormGroupCard(
              title: 'Additional Information',
              children: [
                LabeledTextField(
                  label: 'Location (Optional)',
                  icon: Icons.location_on,
                  controller: _locationController,
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _submitForm,
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
                minimumSize: const Size.fromHeight(48),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Add Entry',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _calculateTotal() {
    try {
      final volume = double.tryParse(_volumeController.text) ?? 0;
      final price = double.tryParse(_priceController.text) ?? 0;
      final total = volume * price;
      print('Calculating total: $volume * $price = $total');
      return NumberFormat.currency(symbol: '\$').format(total);
    } catch (e) {
      print('Error calculating total: $e');
      return '\$0.00';
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final entry = FuelEntry(
          id: widget.entry?.id,
          date: _selectedDate,
          odometerReading: double.parse(_odometerController.text),
          fuelVolume: double.parse(_volumeController.text),
          pricePerUnit: double.parse(_priceController.text),
          location: _locationController.text.isEmpty
              ? null
              : _locationController.text,
          totalCost: double.parse(_priceController.text) *
              double.parse(_volumeController.text),
        );

        if (widget.entry == null) {
          await ref.read(fuelEntriesProvider.notifier).addEntry(entry);
        } else {
          await ref.read(fuelEntriesProvider.notifier).updateEntry(entry);
        }

        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to ${widget.entry == null ? 'add' : 'update'} entry: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
