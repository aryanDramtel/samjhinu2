import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';

part 'geofence.g.dart';

@HiveType(typeId: 0)
class Geofence extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  int radius;

  @HiveField(3)
  double latitude;

  @HiveField(4)
  double longitude;

  Geofence({
    required this.title,
    required this.description,
    required this.radius,
    required this.latitude,
    required this.longitude,
  });

  LatLng get location => LatLng(latitude, longitude);
}
