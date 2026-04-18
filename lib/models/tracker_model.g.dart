// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracker_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackerModelAdapter extends TypeAdapter<TrackerModel> {
  @override
  final int typeId = 1;

  @override
  TrackerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrackerModel(
      name: fields[0] as String,
      category: fields[1] as String,
      value: fields[2] as String,
      status: fields[3] as String,
      isFavorite: fields[4] as bool,
      colorValue: fields[5] as int,
      iconCodePoint: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TrackerModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.value)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.isFavorite)
      ..writeByte(5)
      ..write(obj.colorValue)
      ..writeByte(6)
      ..write(obj.iconCodePoint);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
