// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glucose_reading.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GlucoseReadingAdapter extends TypeAdapter<GlucoseReading> {
  @override
  final int typeId = 6;

  @override
  GlucoseReading read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GlucoseReading(
      id: fields[0] as String,
      value: fields[1] as double,
      timestamp: fields[2] as DateTime,
      source: fields[3] as String,
      imagePath: fields[4] as String?,
      notes: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GlucoseReading obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.source)
      ..writeByte(4)
      ..write(obj.imagePath)
      ..writeByte(5)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GlucoseReadingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
