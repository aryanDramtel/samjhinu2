import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/geofence.dart';
import 'screens/reminder_form_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(GeofenceAdapter());
  await Hive.openBox<Geofence>('geofences');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Samjhinu2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Samjhinu2'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Box<Geofence> _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box<Geofence>('geofences');
  }

  Future<void> _refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ValueListenableBuilder(
          valueListenable: _box.listenable(),
          builder: (context, Box<Geofence> box, _) {
            if (box.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 300),
                  Center(child: Text('No reminders yet.')),
                ],
              );
            }

            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final reminder = box.getAt(index)!;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.alarm),
                        title: Text(reminder.title),
                        subtitle: Text(
                          '${reminder.description}\nRadius: ${reminder.radius}m\nLocation: ${reminder.latitude.toStringAsFixed(4)}, ${reminder.longitude.toStringAsFixed(4)}',
                        ),
                        isThreeLine: true,
                        trailing: Switch(
                          value: reminder.isEnabled,
                          onChanged: (val) async {
                            final updated = Geofence(
                              title: reminder.title,
                              description: reminder.description,
                              radius: reminder.radius,
                              latitude: reminder.latitude,
                              longitude: reminder.longitude,
                              isEnabled: val,
                            );
                            await _box.putAt(index, updated);
                            _refresh();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(val ? 'Reminder ON' : 'Reminder OFF')),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              icon: const Icon(Icons.edit, size: 18),
                              label: const Text('Edit'),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ReminderFormScreen(
                                      existingReminder: reminder,
                                      index: index,
                                    ),
                                  ),
                                );
                                _refresh();
                              },
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              icon: const Icon(Icons.delete, size: 18),
                              label: const Text('Delete'),
                              onPressed: () {
                                _box.deleteAt(index);
                                _refresh();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReminderFormScreen(),
            ),
          ).then((_) => _refresh());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
