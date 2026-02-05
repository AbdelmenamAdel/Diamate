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
    );
  }

  @override
  void write(BinaryWriter writer, DfuTestModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.imagePaths)
      ..writeByte(2)
      ..write(obj.addDate);
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
