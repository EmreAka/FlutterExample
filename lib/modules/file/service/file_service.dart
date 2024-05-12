import 'package:flutter_example/core/interfaces/download_file_manager_interface.dart';
import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/modules/file/interfaces/file_service_interface.dart';

class FileService implements IFileService {
  final IDownloadFileManager _downloadFileManager;

  FileService({
    required IDownloadFileManager downloadFileManager,
  }) : _downloadFileManager = downloadFileManager;

  @override
  Future<Result<bool, Exception>> downloadFile(String fileUrl, String fileName) async {
    final downloadResult = await _downloadFileManager.downloadFile(fileUrl, fileName);
    return downloadResult;
  }
}