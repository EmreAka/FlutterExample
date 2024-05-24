import 'package:flutter/material.dart';
import 'package:flutter_example/modules/dog/models/dog_model.dart';

class DogListWidget extends StatelessWidget {
  final List<DogModel> dogs;
  final ScrollController scrollController;

  const DogListWidget({
    super.key,
    required this.dogs,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      controller: scrollController,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: dogs.length,
      itemBuilder: (context, index) {
        final dog = dogs[index];
        return Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.onInverseSurface,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(dog.image),
            ),
            title: Text(dog.name),
            subtitle: Text('${dog.breed} - ${dog.age} years old'),
          ),
        );
      },
    );
  }
}
