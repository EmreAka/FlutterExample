import 'package:flutter_example/modules/home/models/post/post_model.dart';

sealed class HomeState {
  const HomeState();
}

final class SuccessState extends HomeState {
  const SuccessState(this.value);
  final List<PostModel> value;
}

final class ErrorState extends HomeState {
  const ErrorState();
}

final class IdleState extends HomeState {
  const IdleState();
}

final class LoadingState extends HomeState {
  const LoadingState();
}