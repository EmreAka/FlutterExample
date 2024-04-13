import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/shared/models/user.model.dart';

abstract interface class IAuthService {
  Future<Result<UserModel, Exception>> login(String email, String password);
}