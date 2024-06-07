import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/shared/interfaces/auth_service_interface.dart';
import 'package:flutter_example/shared/clients/users_http_client.dart';
import 'package:flutter_example/shared/models/user.model.dart';

class AuthService implements IAuthService {
  final IUserHttpClient _userHttpClient;

  AuthService({
    required IUserHttpClient userHttpClient,
  }) : _userHttpClient = userHttpClient;

  @override
  Future<Result<UserModel, Exception>> login(String email, String password) async {
    final users = await _userHttpClient.getUser(email);

    switch (users) {
      case Success(value: final users):
        if (users.isNotEmpty) {
          return Success(users.first);
        }
        return Failure(Exception('User not found'));
      case Failure(exception: final exception):
        return Failure(exception);
    }
  }
}
