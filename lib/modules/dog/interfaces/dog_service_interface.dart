import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/modules/dog/models/dog_model.dart';

abstract interface class IDogService {
  Future<Result<List<DogModel>, Exception>> getDogsPaginated({
    required int page,
    required int pageSize,
  });

  Future<Result<List<DogModel>, Exception>> searchDogs({
    required String query,
  });
}