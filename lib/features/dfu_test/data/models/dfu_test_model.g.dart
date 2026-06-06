// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dfu_test_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DfuTestModelAdapter extends TypeAdapter<DfuTestModel> {
  @override
  final int typeId = 5;

  @override
  DfuTestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DfuTestModel(
      name: fields[0] as String,
      imagePaths: (fields[1] as List).cast<String>(),
      addDate: fields[2] as DateTime,
      ulcerDetected: fields[3] as bool?,
      ulcerCoverage: fields[4] as double?,
      ulcerPixels: fields[5] as int?,
      overlayImagePath: fields[6] as String?,
      inferenceMs: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, DfuTestModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.imagePaths)
      ..writeByte(2)
      ..write(obj.addDate)
      ..writeByte(3)
      ..write(obj.ulcerDetected)
      ..writeByte(4)
      ..write(obj.ulcerCoverage)
      ..writeByte(5)
      ..write(obj.ulcerPixels)
      ..writeByte(6)
      ..write(obj.overlayImagePath)
      ..writeByte(7)
      ..write(obj.inferenceMs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DfuTestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
