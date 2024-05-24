class DogModel {
  final String name;
  final String breed;
  final int age;
  final String image;
  final String description;

  const DogModel({
    required this.name,
    required this.breed,
    required this.age,
    required this.description,
    this.image =
        'https://www.vidavetcare.com/wp-content/uploads/sites/234/2022/04/golden-retriever-dog-breed-info.jpeg',
  });
}
