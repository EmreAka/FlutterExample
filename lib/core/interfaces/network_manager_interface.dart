import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_example/core/models/network/http_result_model.dart';

abstract class INetworkManager {
  void addBearerToken(String bearerToken);

  Future<HttpResult<dynamic, HttpException>> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  });

  Future<HttpResult<dynamic, HttpException>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  });

  Future<HttpResult<dynamic, HttpException>> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  });

  Future<HttpResult<dynamic, HttpException>> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  });

  Future<HttpResult<dynamic, HttpException>> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  });
}
