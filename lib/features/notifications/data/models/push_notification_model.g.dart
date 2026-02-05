// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PushNotificationModelAdapter extends TypeAdapter<PushNotificationModel> {
  @override
  final int typeId = 3;

  @override
  PushNotificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PushNotificationModel(
      title: fields[0] as String,
      body: fields[1] as String,
      productId: fields[2] as String,
      createAt: fields[3] as DateTime,
      isRead: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PushNotificationModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.body)
      ..writeByte(2)
      ..write(obj.productId)
      ..writeByte(3)
      ..write(obj.createAt)
      ..writeByte(4)
      ..write(obj.isRead);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PushNotificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
