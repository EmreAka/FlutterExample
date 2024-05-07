import 'package:flutter_example/core/models/result_model.dart';

abstract interface class IDownloadFileManager {
  Future<Result<bool, Exception>> downloadFile();
}