import 'package:flutter_example/modules/dog/models/dog_model.dart';

sealed class DogViewState {}

final class IdleState extends DogViewState {}

final class LoadingState extends DogViewState {}

final class LoadingMoreState extends DogViewState {
  final List<DogModel> dogs;

  LoadingMoreState(this.dogs);
}

final class RefreshingState extends DogViewState {
  final List<DogModel> dogs;

  RefreshingState(this.dogs);
}

final class FailedState extends DogViewState {
  final Exception error;

  FailedState(this.error);
}

final class LoadedState extends DogViewState {
  final List<DogModel> dogs;
  final int page;
  final int pageSize;
  final bool isAllLoaded;

  LoadedState(
    this.dogs,
    this.page,
    this.pageSize,
    this.isAllLoaded,
  );
}

final class SearcingState extends DogViewState {
  final List<DogModel> dogs;

  SearcingState(this.dogs);
}

final class SearchLoadedState extends DogViewState {
  final List<DogModel> dogs;

  SearchLoadedState(this.dogs);
}