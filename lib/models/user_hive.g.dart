// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserhiveAdapter extends TypeAdapter<User_hive> {
  @override
  final int typeId = 1;

  @override
  User_hive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User_hive(
      userID: fields[3] as String,
      firstname: fields[0] as String,
      lastname: fields[1] as String,
      email: fields[4] as String,
      phone: fields[5] as String,
      country: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User_hive obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.firstname)
      ..writeByte(1)
      ..write(obj.lastname)
      ..writeByte(2)
      ..write(obj.country)
      ..writeByte(3)
      ..write(obj.userID)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserhiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
