import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/modules/auth/interfaces/auth_service_interface.dart';
import 'package:flutter_example/shared/clients/users_http_client.dart';
import 'package:flutter_example/shared/models/user.model.dart';

class AuthService implements IAuthService{
  final IUserHttpClient _userHttpClient;

  AuthService(this._userHttpClient);

  @override
  Future<Result<UserModel, Exception>> login(String email, String password) async {
    final users = await _userHttpClient.getUsers();

    if (users is Success) {
      final user = _findUserByEmail((users as Success<List<UserModel>, Exception>).value, email);

      return user;
    }

    return Failure((users as Failure).exception);
  }

  Result<UserModel, Exception> _findUserByEmail(List<UserModel> users, String email) {
    try {
      final user = users.firstWhere((user) => user.email == email);
      return Success(user);
    } catch (e) {
      return Failure(Exception('Credentials are wrong'));
    }
  }
}
