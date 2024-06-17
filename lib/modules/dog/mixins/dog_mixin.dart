import 'package:flutter/material.dart';
import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/modules/dog/state/dog_view_state.dart';
import 'package:flutter_example/modules/dog/view/dogs_view.dart';
import 'package:signals/signals.dart';

mixin DogsMixin on State<DogsView> {
  final viewState = signal<DogViewState>(IdleState());

  bool get isLoaded =>
      viewState() is LoadedState || viewState() is SearchLoadedState;

  bool get isSearching => viewState() is SearcingState;

  final _scrollController = ScrollController();

  ScrollController get scrollController => _scrollController;

  bool get _isEndOfList =>
      _scrollController.position.maxScrollExtent == _scrollController.offset;

  final searchTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _loadDogs();

    _registerScrollControllerListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    viewState.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    searchTextFieldController.clear();

    viewState.set(switch (viewState()) {
      LoadedState(dogs: final dogs) => RefreshingState(dogs),
      SearchLoadedState(dogs: final dogs) => RefreshingState(dogs),
      _ => LoadingState(),
    });

    final result =
        await widget.dogService.getDogsPaginated(page: 1, pageSize: 10);

    final state = switch (result) {
      Success(value: final dogs) => LoadedState(dogs, 1, 10, false),
      Failure(exception: final error) => FailedState(error),
    };

    viewState.set(state);
  }

  void _registerScrollControllerListener() {
    return _scrollController.addListener(
      () async {
        if (_isEndOfList &&
            viewState() is LoadedState &&
            !(viewState() as LoadedState).isAllLoaded) {
          await _loadMoreDogs();
        }

        if (_isEndOfList &&
            viewState() is SearchLoadedState &&
            !(viewState() as SearchLoadedState).isAllLoaded) {
          await _loadMoreSearchResults();
        }
      },
    );
  }

  Future<void> _loadMoreDogs() async {
    if (!isLoaded) return;

    final loadedState = viewState() as LoadedState;

    viewState.set(LoadingMoreState(loadedState.dogs));

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

    viewState.set(state);
  }

  Future<void> _loadDogs() async {
    viewState.set(LoadingState());

    final result =
        await widget.dogService.getDogsPaginated(page: 1, pageSize: 10);

    final state = switch (result) {
      Success(value: final dogs) => LoadedState(dogs, 1, 10, false),
      Failure(exception: final error) => FailedState(error),
    };

    viewState.set(state);
  }

  Future<void> onSearch(String text) async {
    if (text.isEmpty) {
      _loadDogs();
      return;
    }

    final state = switch (viewState()) {
      LoadedState(dogs: final dogs) => SearcingState(dogs),
      _ => SearcingState([]),
    };  

    viewState.set(state);

    final result =
        await widget.dogService.searchDogs(page: 1, pageSize: 10, query: text);

    final searchState = switch (result) {
      Success(value: final dogs) => SearchLoadedState(dogs, 1, 10, false),
      Failure(exception: final error) => FailedState(error),
    };

    viewState.set(searchState);
  }

  Future<void> _loadMoreSearchResults() async {
    if (!isLoaded) return;

    final loadedState = viewState() as SearchLoadedState;

    viewState.set(LoadingMoreState(loadedState.dogs));

    final result = await widget.dogService.searchDogs(
      page: loadedState.page + 1,
      pageSize: loadedState.pageSize,
      query: searchTextFieldController.text,
    );

    final state = switch (result) {
      Success(value: final dogs) => SearchLoadedState(
          loadedState.dogs + dogs,
          loadedState.page + 1,
          loadedState.pageSize,
          dogs.isEmpty,
        ),
      Failure(exception: final error) => FailedState(error),
    };

    viewState.set(state);
  }
}
