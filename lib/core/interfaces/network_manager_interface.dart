import 'dart:io';
import 'package:flutter_example/core/models/model_interface.dart';
import 'package:flutter_example/core/models/network/http_result_model.dart';

abstract class INetworkManager {
  void addBearerToken(String bearerToken);

  Future<HttpResult<dynamic, HttpException>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  });

  Future<HttpResult<dynamic, HttpException>> post(
    String path, {
    IModel? data,
    Map<String, dynamic>? queryParameters,
  });

  Future<HttpResult<dynamic, HttpException>> put(
    String path, {
    IModel? data,
    Map<String, dynamic>? queryParameters,
  });

  Future<HttpResult<dynamic, HttpException>> patch(
    String path, {
    IModel? data,
    Map<String, dynamic>? queryParameters,
  });

  Future<HttpResult<dynamic, HttpException>> delete(
    String path, {
    IModel? data,
    Map<String, dynamic>? queryParameters,
  });
}
