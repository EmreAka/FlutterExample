import 'package:flutter/material.dart';
import 'package:flutter_example/core/constants/network_constants.dart';
import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/modules/file/view/file_view.dart';

mixin FileMixin on State<FileView> {
  void showMaxDownloadsReachedSnackBar();

  Future<void> downloadFile() async {
    final tasks = [
      widget.fileService.downloadFile(NetworkConstants.imageUrl, 'smallImage'),
      widget.fileService.downloadFile(NetworkConstants.largeImageUrl, 'largeImage'),
    ];

    final results = await Future.wait(tasks);

    for (final result in results) {
      if (result is Failure) {
        showMaxDownloadsReachedSnackBar();
        break;
      }
    }
  }

  Future<void> downloadFileSmall() async {
    final result = await widget.fileService.downloadFile(NetworkConstants.imageUrl, 'smallImage');

    if (result is Failure) showMaxDownloadsReachedSnackBar();
  }

  Future<void> downloadFileLarge() async {
    final result = await widget.fileService.downloadFile(NetworkConstants.largeImageUrl, 'largeImage');
    if (result is Failure) showMaxDownloadsReachedSnackBar();
  }

  Future<void> openFile(String filePath) async {
    final result = await widget.fileService.openFile(filePath);

    if (result is Failure && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to open file. '),
        ),
      );
    }
  }
}