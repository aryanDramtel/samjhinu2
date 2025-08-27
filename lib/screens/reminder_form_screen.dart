import 'package:flutter/material.dart';

class ReminderFormScreen extends StatefulWidget {
  const ReminderFormScreen({Key? key}) : super(key: key);

  @override
  State<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends State<ReminderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  int _radius = 50;

  final List<int> radiusOptions = [10, 20, 50, 100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Reminder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) => _title = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
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
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState?.save();
                  // We'll handle saving later
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reminder saved (stub)')),
                  );
                },
                child: const Text('Save Reminder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
