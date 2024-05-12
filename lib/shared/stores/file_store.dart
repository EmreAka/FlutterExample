import 'dart:developer';

import 'package:flutter_example/core/constants/app_constants.dart';
import 'package:signals/signals_flutter.dart';

final class FileStoreModel {
  final String id;
  final String fileName;
  String? _path;
  String? _fileExtension;
  int _progress;
  int get progress => _progress;
  String? get path => _path;
  String? get fileExtension => _fileExtension;

  FileStoreModel({
    required this.id,
    required this.fileName,
    required int progress,
    String? path,
    String? fileExtension,
  })  : _progress = progress,
        _path = path;

  void updateProgress(int progress) {
    _progress = progress;
  }

  void updatePath(String path) {
    _path = path;
  }

  void updateFileExtension(String fileExtension) {
    _fileExtension = fileExtension;
  }
}

final class FileStore {
  final _fileDownloadQueue = signal<List<FileStoreModel>>([]);
  ReadonlySignal<List<FileStoreModel>> get fileDownloadQueue => _fileDownloadQueue.readonly();

  bool addFileToDownloadQueue(FileStoreModel file) {
    final currentQueue = _fileDownloadQueue.value;

    final countOfDownloadsInProgress = currentQueue.where((element) => element.progress < 100).length;

    if (countOfDownloadsInProgress >= AppConstants.maxConcurrentDownloads) {
      return false;
    }

    currentQueue.add(file);

    _fileDownloadQueue.value = [...currentQueue];
    return true;
  }

  void removeFileFromDownloadQueue(String id) {
    final currentQueue = _fileDownloadQueue.value;
    currentQueue.removeWhere((element) => element.id == id);

    _fileDownloadQueue.value = [...currentQueue];
  }

  bool updateProgress(String id, int progress) {
    try {
      final currentQueue = _fileDownloadQueue.value;
      final fileToUpdate = currentQueue.firstWhere((element) => element.id == id);

      fileToUpdate.updateProgress(progress);

      _fileDownloadQueue.value = [...currentQueue];
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  bool updatePath(String id, String path) {
    try {
      final currentQueue = _fileDownloadQueue.value;
      final fileToUpdate = currentQueue.firstWhere((element) => element.id == id);

      fileToUpdate.updatePath(path);

      _fileDownloadQueue.value = [...currentQueue];
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  bool updateFileExtension(String id, String fileExtension) {
    try {
      final currentQueue = _fileDownloadQueue.value;
      final fileToUpdate = currentQueue.firstWhere((element) => element.id == id);

      fileToUpdate.updateFileExtension(fileExtension);

      _fileDownloadQueue.value = [...currentQueue];
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
