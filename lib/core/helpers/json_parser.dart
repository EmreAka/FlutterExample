import 'package:flutter_example/core/models/result_model.dart';

class JsonParser {
  static Result<List<T>, Exception> parseList<T>(
      T Function(Map<String, Object?>) fromJson, Object? response) {
    try {
      if (response != null && response is List) {
        final result = response
            .map((map) => fromJson(map as Map<String, Object?>))
            .toList();
        return Success(result);
      }
      throw Exception('A problem occurred while parsing');
    } catch (e) {
      return Failure(Exception('A problem occurred while parsing'));
    }
  }

  static Result<T, Exception> parseMap<T>(
      T Function(Map<String, Object?>) fromJson, Object? response) {
    try {
      if (response != null && response is Map) {
        final result = fromJson(response as Map<String, Object?>);
        return Success(result);
      }

      throw Exception('A problem occurred while parsing');
    } catch (e) {
      return Failure(Exception('A problem occurred while parsing'));
    }
  }
}