import 'package:flutter_example/core/models/result_model.dart';

abstract interface class IFileService {
  Future<Result<bool, Exception>> downloadFile(String fileUrl, String fileName);
}