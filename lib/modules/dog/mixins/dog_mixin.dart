import 'package:flutter/material.dart';
import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/modules/dog/state/dog_view_state.dart';
import 'package:flutter_example/modules/dog/view/dogs_view.dart';

mixin DogsMixin on State<DogsView> {
  DogViewState viewState = IdleState();

  final _scrollController = ScrollController();

  ScrollController get scrollController => _scrollController;

  bool get _isEndOfList => _scrollController.position.maxScrollExtent == _scrollController.offset;

  @override
  void initState() {
    super.initState();

    _loadDogs();

    _registerScrollControllerListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    setState(() {
      viewState = switch (viewState) {
        LoadedState(dogs: final dogs) => RefreshingState(dogs),
        _ => LoadingState(),
      };
    });

    final result = await widget.dogService.getDogsPaginated(page: 1, pageSize: 10);

    final state = switch (result) {
      Success(value: final dogs) => LoadedState(dogs, 1, 10, false),
      Failure(exception: final error) => FailedState(error),
    };

    setState(() {
      viewState = state;
    });
  }

  void _registerScrollControllerListener() {
    return _scrollController.addListener(
      () async {
        if (_isEndOfList && viewState is LoadedState && !(viewState as LoadedState).isAllLoaded) {
          await _loadMoreDogs();
        }
      },
    );
  }

  Future<void> _loadMoreDogs() async {
    final loadedState = viewState as LoadedState;

    setState(() {
      viewState = LoadingMoreState(loadedState.dogs);
    });

    final result = await widget.dogService.getDogsPaginated(
      page: loadedState.page + 1,
      pageSize: loadedState.pageSize,
    );

    final state = switch (result) {
      Success(value: final dogs) => LoadedState(
          loadedState.dogs + dogs,
          loadedState.page + 1,
          loadedState.pageSize,
          dogs.isEmpty,
        ),
      Failure(exception: final error) => FailedState(error),
    };

    setState(() {
      viewState = state;
    });
  }

  Future<void> _loadDogs() async {
    setState(() {
      viewState = LoadingState();
    });

    final result = await widget.dogService.getDogsPaginated(page: 1, pageSize: 10);

    final state = switch (result) {
      Success(value: final dogs) => LoadedState(dogs, 1, 10, false),
      Failure(exception: final error) => FailedState(error),
    };

    setState(() {
      viewState = state;
    });
  }
}
