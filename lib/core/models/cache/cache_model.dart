import 'package:flutter_example/core/models/model_interface.dart';

class CacheModel implements IModel<CacheModel> {
  final Expire expiration;

  final String value;

  CacheModel({
    required this.expiration,
    required this.value,
  });

  factory CacheModel.fromJson(Map<String, Object?> json) {
    return CacheModel(
      expiration: (json['expiration'] as Map<String, Object?>).isNotEmpty
          ? Expirable.fromJson(json['expiration'] as Map<String, Object?>)
          : NonExpirable(),
      value: json['value'] as String,
    );
  }

  @override
  CacheModel fromJson(Map<String, Object?> json) => CacheModel.fromJson(json);

  @override
  Map<String, Object?> toJson() => {
        'expiration': expiration.toJson(),
        'value': value,
      };
}

sealed class Expire implements IModel<Expire> {}

class Expirable extends Expire {
  final DateTime expiration;

  Expirable(this.expiration);

  factory Expirable.fromJson(Map<String, Object?> json) {
    return Expirable(
      DateTime.parse(json['expiration'] as String),
    );
  }

  @override
  fromJson(Map<String, Object?> json) => Expirable.fromJson(json);

  @override
  Map<String, Object?> toJson() => {
        'expiration': expiration.toIso8601String(),
      };
}

class NonExpirable extends Expire {
  NonExpirable();

  factory NonExpirable.fromJson(Map<String, Object?> json) {
    return NonExpirable();
  }

  @override
  NonExpirable fromJson(Map<String, Object?> json) => NonExpirable.fromJson(json);

  @override
  Map<String, Object?> toJson() => {};
}
