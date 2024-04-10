import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_example/core/interfaces/network_manager_interface.dart';
import 'package:flutter_example/core/models/network/http_result_model.dart';

class DioNetworkManager implements INetworkManager {
  late final Dio _dio;

  DioNetworkManager(String baseUrl) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      validateStatus: (status) => true,
    ));
  }

  DioNetworkManager.withToken(String baseUrl, String bearerToken) {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  @override
  void addBearerToken(String bearerToken) {
    _dio.options = _dio.options
        .copyWith(headers: {'Authorization': 'Bearer $bearerToken'});
  }

  @override
  Future<HttpResult<dynamic, HttpException>> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var dioResponse = await _dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      final result = _toHttpResult(dioResponse);

      return result;
    } catch (error) {
      return InternalServerError(HttpException(error.toString()));
    }
  }

  @override
  Future<HttpResult<dynamic, HttpException>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final dioResponse = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      final result = _toHttpResult(dioResponse);
      return result;
    } catch (error) {
      return InternalServerError(HttpException(error.toString()));
    }
  }

  @override
  Future<HttpResult<dynamic, HttpException>> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final dioResponse = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      final result = _toHttpResult(dioResponse);
      return result;
    } catch (error) {
      return InternalServerError(HttpException(error.toString()));
    }
  }

  @override
  Future<HttpResult<dynamic, HttpException>> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final dioResponse = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      final result = _toHttpResult(dioResponse);
      return result;
    } catch (error) {
      return InternalServerError(HttpException(error.toString()));
    }
  }

  @override
  Future<HttpResult<dynamic, HttpException>> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final dioResponse = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      final result = _toHttpResult(dioResponse);
      return result;
    } catch (error) {
      return InternalServerError(HttpException(error.toString()));
    }
  }

  HttpResult<dynamic, HttpException> _toHttpResult(
      Response<dynamic> dioResponse) {
    final HttpResult<dynamic, HttpException> result =
        switch (dioResponse.statusCode) {
      200 => Ok(dioResponse.data),
      201 => Created(dioResponse.data),
      204 => const NoContent(),
      400 =>
        BadRequest(HttpException('Bad Request: ${dioResponse.statusMessage}')),
      401 => Unauthorized(
          HttpException('Unauthorized: ${dioResponse.statusMessage}')),
      403 => Forbid(HttpException('Forbidden: ${dioResponse.statusMessage}')),
      404 => NotFound(HttpException('Not Found: ${dioResponse.statusMessage}')),
      409 => Conflict(HttpException('Conflict: ${dioResponse.statusMessage}')),
      500 => InternalServerError(
          HttpException('Internal Server Error: ${dioResponse.statusMessage}')),
      _ => InternalServerError(
          HttpException('Internal Server Error: ${dioResponse.statusMessage}')),
    };

    return result;
  }
}
