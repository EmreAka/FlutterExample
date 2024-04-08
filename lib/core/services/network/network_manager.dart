import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_example/core/models/network/http_result_model.dart';

abstract class INetworkManager {
  void addBearerToken(String bearerToken);

  Future<HttpResult<dynamic, HttpException>> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  });

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });
}

class NetworkManager implements INetworkManager {
  late final Dio _dio;

  NetworkManager(String baseUrl) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      validateStatus: (status) => true,
    ));
  }

  NetworkManager.withToken(String baseUrl, String bearerToken) {
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
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var dioResponse = await _dio.get(path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);

      final result = _toHttpResult(dioResponse);

      return result;
    } catch (error) {
      return InternalServerError(HttpException(error.toString()));
    }
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.post<T>(path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  @override
  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.put<T>(path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  @override
  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.patch<T>(path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  @override
  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.delete<T>(path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken);
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
