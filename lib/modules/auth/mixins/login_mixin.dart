import 'package:flutter/material.dart';
import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/modules/auth/views/login_view.dart';
import 'package:go_router/go_router.dart';

mixin LoginMixin on State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    final result = await widget.authService.login(
      emailController.text,
      passwordController.text,
    );

    if (result is Success && mounted) {
      context.goNamed('home');
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(child: Text('Credentials are wrong')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
