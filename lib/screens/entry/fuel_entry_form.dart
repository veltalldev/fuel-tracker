import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/fuel_entry.dart';
import '../../repositories/providers/fuel_entries_provider.dart';
import '../../utils/validators.dart';

class FuelEntryForm extends ConsumerStatefulWidget {
  final FuelEntry? entry;

  const FuelEntryForm({
    super.key,
    this.entry,
  });

  @override
  ConsumerState<FuelEntryForm> createState() => _FuelEntryFormState();
}

class _FuelEntryFormState extends ConsumerState<FuelEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _odometerController = TextEditingController();
  final _volumeController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _selectedDate = widget.entry!.date;
      _dateController.text = DateFormat.yMMMd().format(_selectedDate);
      _odometerController.text = widget.entry!.odometerReading.toString();
      _volumeController.text = widget.entry!.fuelVolume.toString();
      _priceController.text = widget.entry!.pricePerUnit.toString();
      _locationController.text = widget.entry!.location ?? '';
    } else {
      _dateController.text = DateFormat.yMMMd().format(_selectedDate);
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _odometerController.dispose();
    _volumeController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat.yMMMd().format(_selectedDate);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final odometer = double.parse(_odometerController.text);
        final volume = double.parse(_volumeController.text);
        final price = double.parse(_priceController.text);
        final location = _locationController.text.trim();

        final entry = FuelEntry(
          id: widget.entry?.id,
          date: _selectedDate,
          odometerReading: odometer,
          fuelVolume: volume,
          pricePerUnit: price,
          totalCost: volume * price,
          location: location.isEmpty ? null : location,
          milesPerGallon: widget.entry?.milesPerGallon,
        );

        if (widget.entry == null) {
          await ref.read(fuelEntriesProvider.notifier).addEntry(entry);
        } else {
          await ref.read(fuelEntriesProvider.notifier).updateEntry(entry);
        }

        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving entry: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.entry == null ? 'Add Fuel Entry' : 'Edit Fuel Entry'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Date Field
            TextFormField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Date',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
              validator: (value) => Validators.validateDate(_selectedDate),
            ),
            const SizedBox(height: 16.0),

            // Odometer Reading
            TextFormField(
              controller: _odometerController,
              decoration: const InputDecoration(
                labelText: 'Odometer Reading',
                suffixText: 'miles',
                prefixIcon: Icon(Icons.speed),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              validator: Validators.validateOdometerReading,
            ),
            const SizedBox(height: 16.0),

            // Fuel Volume
            TextFormField(
              controller: _volumeController,
              decoration: const InputDecoration(
                labelText: 'Fuel Volume',
                suffixText: 'gallons',
                prefixIcon: Icon(Icons.local_gas_station),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              validator: Validators.validateFuelVolume,
            ),
            const SizedBox(height: 16.0),

            // Price per Gallon
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price per Gallon',
                prefixText: '\$',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              validator: Validators.validatePrice,
            ),
            const SizedBox(height: 16.0),

            // Location (Optional)
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location (Optional)',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              maxLength: 100,
            ),
            const SizedBox(height: 16.0),

            // Submit Button
            FilledButton(
              onPressed: _isLoading ? null : _submitForm,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        widget.entry == null ? 'Add Entry' : 'Update Entry',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
