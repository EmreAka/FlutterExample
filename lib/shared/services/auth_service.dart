import 'dart:developer';

import 'package:flutter_example/core/interfaces/cache_manager_interface.dart';
import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/shared/interfaces/auth_service_interface.dart';
import 'package:flutter_example/shared/clients/users_http_client.dart';
import 'package:flutter_example/shared/models/user.model.dart';

class AuthService implements IAuthService {
  final IUserHttpClient _userHttpClient;
  final ICacheManager _cacheManager;

  AuthService({
    required IUserHttpClient userHttpClient,
    required ICacheManager cacheManager,
  })  : _userHttpClient = userHttpClient,
        _cacheManager = cacheManager;

  @override
  Future<Result<UserModel, Exception>> login(String email, String password) async {
    final users = await _userHttpClient.getUser(email);

    switch (users) {
      case Success(value: final users):
        if (users.isNotEmpty) {
          await _cacheManager.putItem('user', users.first);
          log('User DB Write');
          return Success(users.first);
        }
        return Failure(Exception('User not found'));
      case Failure(exception: final exception):
        return Failure(exception);
    }
  }
}
