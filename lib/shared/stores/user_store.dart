import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/shared/interfaces/auth_service_interface.dart';
import 'package:flutter_example/shared/models/user.model.dart';
import 'package:signals/signals_flutter.dart';

final class UserStore {
  final IAuthService _authService;

  UserStore({
    required IAuthService authService,
  }) : _authService = authService;

  final _user = signal<UserModel?>(null);

  ReadonlySignal<UserModel?> get user => _user.readonly();
  ReadonlySignal<bool> get isLoggedIn => computed(() => _user() != null);

  Future<Result<UserModel, Exception>> signIn({
    required String email,
    required String password,
  }) async {
    final result = await _authService.login(email, password);

    switch (result) {
      case Success(value: final user):
        _user.value = user;
        return Success(user);
      case Failure(exception: final exception):
        return Failure(exception);
    }
  }

  void signOut() {
    _user.value = null;
  }
}
