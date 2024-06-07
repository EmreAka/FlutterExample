import 'package:flutter_example/shared/constants/hive_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'cache_model.g.dart';

@HiveType(typeId: HiveConstants.cacheTypeId)
class CacheModel {
  @HiveField(1)
  final Expire expiration;

  @HiveField(2)
  final dynamic value;

  CacheModel({
    required this.expiration,
    required this.value,
  });
}

sealed class Expire {}

@HiveType(typeId: HiveConstants.expirableTypeId)
class Expirable extends Expire {
  @HiveField(1)
  final DateTime expiration;

  Expirable(this.expiration);
}

@HiveType(typeId: HiveConstants.nonExpirableTypeId)
class NonExpirable extends Expire {
  NonExpirable();
}