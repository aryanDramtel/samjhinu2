// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofence.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeofenceAdapter extends TypeAdapter<Geofence> {
  @override
  final int typeId = 0;

  @override
  Geofence read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Geofence(
      title: fields[0] as String,
      description: fields[1] as String,
      radius: fields[2] as int,
      latitude: fields[3] as double,
      longitude: fields[4] as double,
      isEnabled: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Geofence obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.radius)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude)
      ..writeByte(5)
      ..write(obj.isEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeofenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
