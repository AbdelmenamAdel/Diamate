// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_test_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LabTestModelAdapter extends TypeAdapter<LabTestModel> {
  @override
  final int typeId = 4;

  @override
  LabTestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LabTestModel(
      name: fields[0] as String,
      pdfPath: fields[1] as String,
      addDate: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LabTestModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.pdfPath)
      ..writeByte(2)
      ..write(obj.addDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LabTestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
