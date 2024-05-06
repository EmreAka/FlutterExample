import 'dart:io';
import 'dart:convert';

import 'package:flutter_example/core/interfaces/network_manager_interface.dart';
import 'package:flutter_example/core/models/model_interface.dart';
import 'package:flutter_example/core/models/network/http_result_model.dart';
import 'package:http/http.dart' as http;

class HttpNetworkManager implements INetworkManager {
  final http.Client _httpClient;
  final String? _baseUrl;
  final String bearerToken = '';

  HttpNetworkManager({String? baseUrl})
      : _baseUrl = baseUrl,
        _httpClient = http.Client();

  @override
  void addBearerToken(String bearerToken) {
    bearerToken = bearerToken;
  }

  @override
  Future<HttpResult<dynamic, HttpException>> delete(
    String path, {
    IModel? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final httpResponse = await _httpClient.delete(
        _getUri(path),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $bearerToken'},
        body: jsonEncode(
          data?.toJson(),
        ),
      );

      final result = _toHttpResult(httpResponse);
      return result;
    } catch (error) {
      return InternalServerError(HttpException(error.toString()));
    }
  }

  @override
  Future<HttpResult<dynamic, HttpException>> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final httpResponse = await _httpClient.get(
        _getUri(path),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $bearerToken'},
      );

      final result = _toHttpResult(httpResponse);
      return result;
    } catch (error) {
      return InternalServerError(HttpException(error.toString()));
    }
  }

  @override
  Future<HttpResult<dynamic, HttpException>> patch(String path,
      {IModel? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final httpResponse = await _httpClient.patch(
        _getUri(path),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonEncode(
          data?.toJson(),
        ),
      );

      final result = _toHttpResult(httpResponse);
      return result;
    } catch (error) {
      return InternalServerError(HttpException(error.toString()));
    }
  }

  @override
  Future<HttpResult<dynamic, HttpException>> post(String path,
      {IModel? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final httpResponse = await _httpClient.post(
        _getUri(path),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonEncode(
          data?.toJson(),
        ),
      );

      final result = _toHttpResult(httpResponse);
      return result;
    } catch (error) {
      return InternalServerError(HttpException(error.toString()));
    }
  }

  @override
  Future<HttpResult<dynamic, HttpException>> put(String path,
      {IModel? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final httpResponse = await _httpClient.put(
        _getUri(path),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonEncode(
          data?.toJson(),
        ),
      );

      final result = _toHttpResult(httpResponse);
      return result;
    } catch (error) {
      return InternalServerError(HttpException(error.toString()));
    }
  }

  HttpResult<dynamic, HttpException> _toHttpResult(http.Response httpResponse) {
    final HttpResult<dynamic, HttpException> result = switch (httpResponse.statusCode) {
      200 => Ok(jsonDecode(httpResponse.body)),
      201 => Created(jsonDecode(httpResponse.body)),
      204 => const NoContent(),
      400 => const BadRequest(HttpException('Bad Request')),
      401 => const Unauthorized(HttpException('Unauthorized')),
      403 => const Forbid(HttpException('Forbidden')),
      404 => const NotFound(HttpException('Not Found')),
      409 => const Conflict(HttpException('Conflict')),
      500 => const InternalServerError(HttpException('Internal Server Error')),
      _ => const InternalServerError(HttpException('Internal Server Error')),
    };

    return result;
  }

  Uri _getUri(String path) => _baseUrl != null ? Uri.parse("$_baseUrl$path") : Uri.parse(path);
}
