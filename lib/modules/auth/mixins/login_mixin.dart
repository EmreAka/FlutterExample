import 'package:flutter/widgets.dart';
import 'package:flutter_example/modules/auth/views/login_view.dart';
import 'package:go_router/go_router.dart';

mixin LoginMixin on State<LoginView> {
  void login() {
    if (mounted) context.goNamed('home');
  }
}
