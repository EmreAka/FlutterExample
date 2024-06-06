import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/modules/dog/interfaces/dog_service_interface.dart';
import 'package:flutter_example/modules/dog/models/dog_model.dart';

class DogService implements IDogService {
  final _dogs = [
    const DogModel(
        name: 'Ruby',
        breed: 'Golden retriever',
        age: 2,
        description: 'Ruby is a friendly and energetic Golden Retriever.'),
    const DogModel(
        name: 'Bella', breed: 'Labrador', age: 3, description: 'Bella is a loyal and playful Labrador.'),
    const DogModel(
        name: 'Max', breed: 'Poodle', age: 1, description: 'Max is an intelligent and elegant Poodle.'),
    const DogModel(
        name: 'Charlie',
        breed: 'Bulldog',
        age: 4,
        description: 'Charlie is a strong and determined Bulldog.'),
    const DogModel(
        name: 'Lucy', breed: 'Beagle', age: 2, description: 'Lucy is a curious and friendly Beagle.'),
    const DogModel(
        name: 'Cooper', breed: 'Pug', age: 3, description: 'Cooper is a charming and mischievous Pug.'),
    const DogModel(
        name: 'Daisy',
        breed: 'Siberian Husky',
        age: 1,
        description: 'Daisy is a beautiful and energetic Siberian Husky.'),
    const DogModel(
        name: 'Rocky', breed: 'Dalmatian', age: 4, description: 'Rocky is a loyal and energetic Dalmatian.'),
    const DogModel(
        name: 'Luna', breed: 'Chihuahua', age: 2, description: 'Luna is a small and lively Chihuahua.'),
    const DogModel(
        name: 'Bailey', breed: 'Boxer', age: 3, description: 'Bailey is a strong and playful Boxer.'),
    const DogModel(
        name: 'Buddy', breed: 'Doberman', age: 1, description: 'Buddy is a loyal and protective Doberman.'),
    const DogModel(
        name: 'Maggie',
        breed: 'Rottweiler',
        age: 4,
        description: 'Maggie is a confident and powerful Rottweiler.'),
    const DogModel(
        name: 'Stella',
        breed: 'Great Dane',
        age: 2,
        description: 'Stella is a gentle and majestic Great Dane.'),
    const DogModel(
        name: 'Bear', breed: 'Schnauzer', age: 3, description: 'Bear is an intelligent and alert Schnauzer.'),
    const DogModel(
        name: 'Zoe', breed: 'Shih Tzu', age: 1, description: 'Zoe is a friendly and affectionate Shih Tzu.'),
    const DogModel(
        name: 'Duke', breed: 'Pomeranian', age: 4, description: 'Duke is a lively and confident Pomeranian.'),
    const DogModel(
        name: 'Lola',
        breed: 'Cocker Spaniel',
        age: 2,
        description: 'Lola is a happy and friendly Cocker Spaniel.'),
    const DogModel(
        name: 'Sadie', breed: 'Maltese', age: 3, description: 'Sadie is a gentle and playful Maltese.'),
    const DogModel(
        name: 'Tucker',
        breed: 'Bichon Frise',
        age: 1,
        description: 'Tucker is a cheerful and affectionate Bichon Frise.'),
    const DogModel(
        name: 'Penny',
        breed: 'Papillon',
        age: 4,
        description: 'Penny is an elegant and intelligent Papillon.'),
  ];

  @override
  Future<Result<List<DogModel>, Exception>> getDogsPaginated({
    required int page,
    required int pageSize,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final start = (page - 1) * pageSize;
      final end = start + pageSize;

      if (_isStartIndexIsHigherThanTheLengthOfTheList(start)) {
        return const Success([]);
      }

      final dogs = _dogs.sublist(start, end);

      return Success(dogs);
    } catch (e) {
      return Failure(Exception('Failed to load dogs'));
    }
  }

  @override
  Future<Result<List<DogModel>, Exception>> searchDogs({
    required String query,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final dogs = _dogs
          .where(
            (dog) =>
                _contains(data: dog.name, query: query) ||
                _contains(data: dog.breed, query: query) ||
                _contains(data: dog.description, query: query),
          )
          .toList();

      return Success(dogs);
    } catch (e) {
      return Failure(Exception('Failed to load dogs'));
    }
  }

  bool _contains({required String data, required String query}) =>
      data.toLowerCase().contains(query.toLowerCase());

  bool _isStartIndexIsHigherThanTheLengthOfTheList(int start) => start >= _dogs.length;
}
