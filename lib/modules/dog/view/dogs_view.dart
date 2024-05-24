import 'package:flutter/material.dart';
import 'package:flutter_example/modules/dog/interfaces/dog_service_interface.dart';
import 'package:flutter_example/modules/dog/mixins/dog_mixin.dart';
import 'package:flutter_example/modules/dog/state/dog_view_state.dart';
import 'package:flutter_example/modules/dog/widgets/dog_list_widget.dart';
import 'package:flutter_example/modules/dog/widgets/failed_information_widget.dart';
import 'package:flutter_example/modules/dog/widgets/idle_list_widget.dart';
import 'package:flutter_example/modules/dog/widgets/loading_indicator_widget.dart';

class DogsView extends StatefulWidget {
  final IDogService dogService;

  const DogsView({
    super.key,
    required this.dogService,
  });

  @override
  State<DogsView> createState() => _DogsViewState();
}

class _DogsViewState extends State<DogsView> with DogsMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dogs'),
        bottom: _buildBottomWidget(),
      ),
      body: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildDogsWidget(),
            ],
          )),
    );
  }

  StatelessWidget _buildDogsWidget() {
    return switch (viewState) {
      LoadedState(dogs: final dogs) => DogListWidget(dogs: dogs),
      LoadingMoreState(dogs: final dogs) => DogListWidget(dogs: dogs),
      RefreshingState(dogs: final dogs) => DogListWidget(dogs: dogs),
      FailedState(error: final error) => FailedInformationWidget(error: error),
      _ => const IdleListWidget(),
    };
  }

  LoadingIndicatorWidget? _buildBottomWidget() {
    return switch (viewState) {
      LoadingState() => const LoadingIndicatorWidget(),
      LoadingMoreState() => const LoadingIndicatorWidget(),
      RefreshingState() => const LoadingIndicatorWidget(),
      _ => null,
    };
  }
}
