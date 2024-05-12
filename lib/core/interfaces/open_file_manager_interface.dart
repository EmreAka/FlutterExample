import 'package:flutter_example/core/models/result_model.dart';

abstract interface class IOpenFileManager {
  Future<Result<bool, Exception>> openFile(String filePath);
}