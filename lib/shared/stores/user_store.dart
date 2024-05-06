import 'package:flutter_example/shared/models/user.model.dart';
import 'package:signals/signals_flutter.dart';

final class UserStore {
  final _user = signal<UserModel?>(null);
  ReadonlySignal<UserModel?> get user => _user.readonly();

  void signIn(UserModel user) {
    _user.value = user;
  }

  void signOut() {
    _user.value = null;
  }
}