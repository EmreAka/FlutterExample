import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/modules/auth/interfaces/auth_service_interface.dart';
import 'package:flutter_example/shared/clients/users_http_client.dart';
import 'package:flutter_example/shared/models/user.model.dart';
import 'package:flutter_example/shared/stores/user_store.dart';

class AuthService implements IAuthService {
  final IUserHttpClient _userHttpClient;
  final UserStore _userStore;

  AuthService({
    required IUserHttpClient userHttpClient,
    required UserStore userStore,
  })  : _userHttpClient = userHttpClient,
        _userStore = userStore;

  @override
  Future<Result<UserModel, Exception>> login(String email, String password) async {
    final users = await _userHttpClient.getUser(email);

    switch (users) {
      case Success(value: final users):
        if (users.isNotEmpty) {
          _userStore.signIn(users.first);
          return Success(users.first);
        }
        return Failure(Exception('User not found'));
      case Failure(exception: final exception):
        return Failure(exception);
    }
  }
}
