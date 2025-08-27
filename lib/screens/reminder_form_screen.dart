import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:hive/hive.dart';
import '../widgets/map_picker.dart';
import '../models/geofence.dart';

class ReminderFormScreen extends StatefulWidget {
  final Geofence? existingReminder;
  final int? index;

  const ReminderFormScreen({Key? key, this.existingReminder, this.index}) : super(key: key);

  @override
  State<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends State<ReminderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  int _radius = 50;
  LatLng? _selectedLocation;

  final List<int> radiusOptions = [10, 20, 50, 100];

  @override
  void initState() {
    super.initState();
    if (widget.existingReminder != null) {
      final r = widget.existingReminder!;
      _title = r.title;
      _description = r.description;
      _radius = r.radius;
      _selectedLocation = LatLng(r.latitude, r.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingReminder != null ? 'Edit Reminder' : 'New Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) => _title = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Radius (meters)'),
                value: _radius,
                items: radiusOptions
                    .map((r) => DropdownMenuItem(value: r, child: Text('$r m')))
                    .toList(),
                onChanged: (value) => setState(() => _radius = value ?? 50),
              ),
              const SizedBox(height: 24),
              MapPicker(
                onLocationSelected: (location) {
                  setState(() => _selectedLocation = location);
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  _formKey.currentState?.save();
                  if (_selectedLocation == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a location on the map')),
                    );
                    return;
                  }

                  final geofence = Geofence(
                    title: _title ?? '',
                    description: _description ?? '',
                    radius: _radius,
                    latitude: _selectedLocation!.latitude,
                    longitude: _selectedLocation!.longitude,
                  );

                  final box = Hive.box<Geofence>('geofences');
                  if (widget.index != null) {
                    await box.putAt(widget.index!, geofence);
                  } else {
                    await box.add(geofence);
                  }

                  Navigator.pop(context);
                },
                child: Text(widget.existingReminder != null ? 'Update Reminder' : 'Save Reminder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
