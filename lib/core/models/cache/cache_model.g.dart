// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CacheModelAdapter extends TypeAdapter<CacheModel> {
  @override
  final int typeId = 2;

  @override
  CacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheModel(
      expiration: fields[1] as Expire,
      value: fields[2] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, CacheModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.expiration)
      ..writeByte(2)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExpirableAdapter extends TypeAdapter<Expirable> {
  @override
  final int typeId = 3;

  @override
  Expirable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Expirable(
      fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Expirable obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.expiration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpirableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NonExpirableAdapter extends TypeAdapter<NonExpirable> {
  @override
  final int typeId = 4;

  @override
  NonExpirable read(BinaryReader reader) {
    return NonExpirable();
  }

  @override
  void write(BinaryWriter writer, NonExpirable obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NonExpirableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
