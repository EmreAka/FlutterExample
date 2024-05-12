import 'package:flutter_example/core/interfaces/download_file_manager_interface.dart';
import 'package:flutter_example/core/interfaces/open_file_manager_interface.dart';
import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/modules/file/interfaces/file_service_interface.dart';

class FileService implements IFileService {
  final IDownloadFileManager _downloadFileManager;
  final IOpenFileManager _openFileManager;

  FileService({
    required IDownloadFileManager downloadFileManager,
    required IOpenFileManager openFileManager,
  })  : _downloadFileManager = downloadFileManager,
        _openFileManager = openFileManager;

  @override
  Future<Result<bool, Exception>> downloadFile(String fileUrl, String fileName) async {
    final downloadResult = await _downloadFileManager.downloadFile(fileUrl, fileName);
    return downloadResult;
  }

  @override
  Future<Result<bool, Exception>> openFile(String filePath) async {
    final openResult = await _openFileManager.openFile(filePath);
    return openResult;
  }
}
