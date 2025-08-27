import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapPicker extends StatefulWidget {
  final Function(LatLng) onLocationSelected;

  const MapPicker({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  LatLng _selectedLocation = LatLng(27.7172, 85.3240); // Default: Kathmandu
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    final location = LatLng(position.latitude, position.longitude);
    setState(() {
      _currentLocation = location;
      _mapController.move(location, 15.0);
    });
  }

  Future<List<Map<String, dynamic>>> _getSuggestions(String query) async {
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5');
    final response = await http.get(url, headers: {'User-Agent': 'samjhinu2-app'});
    if (response.statusCode == 200) {
      final results = json.decode(response.body) as List;
      return results.cast<Map<String, dynamic>>();
    }
    return [];
  }

  void _selectSuggestion(Map<String, dynamic> suggestion) {
    final lat = double.parse(suggestion['lat']);
    final lon = double.parse(suggestion['lon']);
    final location = LatLng(lat, lon);
    setState(() {
      _selectedLocation = location;
      _mapController.move(location, 15.0);
      widget.onLocationSelected(location);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TypeAheadField<Map<String, dynamic>>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search location...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          suggestionsCallback: _getSuggestions,
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion['display_name']),
            );
          },
          onSuggestionSelected: _selectSuggestion,
        ),
        const SizedBox(height: 8),
        const Text('Tap on the map to drop a pin'),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: 13.0,
              onTap: (tapPosition, point) {
                setState(() => _selectedLocation = point);
                widget.onLocationSelected(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.aryan.samjhinu2',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                  ),
                  if (_currentLocation != null)
                    Marker(
                      point: _currentLocation!,
                      width: 30,
                      height: 30,
                      child: const Icon(Icons.my_location, color: Colors.blue, size: 30),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
