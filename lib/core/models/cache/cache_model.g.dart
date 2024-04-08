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
      expiration: fields[1] as DateTime,
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
