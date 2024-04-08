
import 'dart:io';

sealed class HttpResult<S, E extends IOException> {
  const HttpResult();
}

// Success Results
final class Ok<S, E extends IOException> extends HttpResult<S, E> {
  const Ok(this.value);
  final S value;
}

final class Created<S, E extends IOException> extends HttpResult<S, E> {
  const Created(this.value);
  final S value;
}

final class NoContent<S, E extends IOException> extends HttpResult<S, E> {
  const NoContent();
}

// Failure Results
final class BadRequest<S, E extends IOException> extends HttpResult<S, E> {
  const BadRequest(this.exception);
  final E exception;
}

final class Unauthorized<S, E extends IOException> extends HttpResult<S, E> {
  const Unauthorized(this.exception);
  final E exception;
}

final class Forbid<S, E extends IOException> extends HttpResult<S, E> {
  const Forbid(this.exception);
  final E exception;
}

final class NotFound<S, E extends IOException> extends HttpResult<S, E> {
  const NotFound(this.exception);
  final E exception;
}

final class Conflict<S, E extends IOException> extends HttpResult<S, E> {
  const Conflict(this.exception);
  final E exception;
}

final class InternalServerError<S, E extends IOException>
    extends HttpResult<S, E> {
  const InternalServerError(this.exception);
  final E exception;
}

sealed class JsonData {
  const JsonData();
}

// Success Results
final class JsonList extends JsonData {
  const JsonList(this.value);
  final List<Map<String, Object?>> value;
}

final class Json extends JsonData {
  const Json(this.value);
  final Map<String, Object?> value;
}
