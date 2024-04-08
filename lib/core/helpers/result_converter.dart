import 'dart:io';
import 'package:flutter_example/core/models/network/http_result_model.dart';
import 'package:flutter_example/core/models/result_model.dart';

class ResultConverter {
  static Result<T, Exception> toResult<T>(
      HttpResult<dynamic, HttpException> httpResult, Result<T, Exception> Function(Object? response) parser) {
    final Result<T, Exception> result = switch (httpResult) {
      Ok(value: final value) => parser(value),
      Created(value: final value) => parser(value),
      NoContent() => Failure(Exception('No Content')),
      BadRequest(exception: final exception) => Failure(exception),
      Unauthorized(exception: final exception) => Failure(exception),
      Forbid(exception: final exception) => Failure(exception),
      NotFound(exception: final exception) => Failure(exception),
      Conflict(exception: final exception) => Failure(exception),
      InternalServerError(exception: final exception) => Failure(exception),
    };

    return result;
  }
}