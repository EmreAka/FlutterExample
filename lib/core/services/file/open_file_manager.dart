import 'package:flutter_example/core/interfaces/open_file_manager_interface.dart';
import 'package:flutter_example/core/models/result_model.dart';
import 'package:open_filex/open_filex.dart';

final class OpenFileXManager implements IOpenFileManager {
  @override
  Future<Result<bool, Exception>> openFile(String filePath) async {
    try {
      final openFileResult = await OpenFilex.open(filePath);
      return switch (openFileResult.type) {
        ResultType.done => const Success(true),
        ResultType.error => Failure(Exception(openFileResult.message)),
        ResultType.noAppToOpen => Failure(Exception(openFileResult.message)),
        ResultType.permissionDenied => Failure(Exception(openFileResult.message)),
        ResultType.fileNotFound => Failure(Exception(openFileResult.message)),
      };
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
