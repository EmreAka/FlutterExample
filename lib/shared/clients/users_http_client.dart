import 'package:flutter_example/core/helpers/json_parser.dart';
import 'package:flutter_example/core/helpers/result_converter.dart';
import 'package:flutter_example/core/interfaces/network_manager_interface.dart';
import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/shared/models/user.model.dart';

abstract class IUserHttpClient {
  Future<Result<List<UserModel>, Exception>> getUsers();
  Future<Result<List<UserModel>, Exception>> getUser(String email);
}

class UserHttpClient implements IUserHttpClient {
  final INetworkManager _networkManager;

  UserHttpClient(this._networkManager);
  
  @override
  Future<Result<List<UserModel>, Exception>> getUsers() async {
    final result = await _networkManager.get('/users');

    final Result<List<UserModel>, Exception> posts = ResultConverter.toResult(
        result, (value) => JsonParser.parseList(UserModel.fromJson, value));

    return posts;
  }
  
  @override
  Future<Result<List<UserModel>, Exception>> getUser(String email) async {
    final result = await _networkManager.get('/users?email=$email');

    final Result<List<UserModel>, Exception> posts = ResultConverter.toResult(
        result, (value) => JsonParser.parseList(UserModel.fromJson, value));

    return posts;
  }


}