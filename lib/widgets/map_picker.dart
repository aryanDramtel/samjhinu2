import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPicker extends StatefulWidget {
  final Function(LatLng) onLocationSelected;

  const MapPicker({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  LatLng _selectedLocation = LatLng(27.7172, 85.3240); // Default: Kathmandu

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Tap on the map to drop a pin'),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: FlutterMap(
            mapController: MapController(),
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
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
