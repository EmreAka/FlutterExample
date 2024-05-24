import 'package:flutter/material.dart';
import 'package:flutter_example/modules/dog/models/dog_model.dart';

class DogListWidget extends StatelessWidget {
  final List<DogModel> dogs;

  const DogListWidget({
    super.key,
    required this.dogs,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: dogs.length,
      itemBuilder: (context, index) {
        final dog = dogs[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.all(0),
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
