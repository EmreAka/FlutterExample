import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter_example/core/constants/network_constants.dart';
import 'package:flutter_example/core/interfaces/download_file_manager_interface.dart';
import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/core/services/permission/permission_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

final class DownloadFileManager implements IDownloadFileManager {
  @override
  Future<Result<bool, Exception>> downloadFile() async {
    try {
      await PermissionService.requestNotificationPermission();

      final directory = Platform.isAndroid
          ? await AndroidPathProvider.downloadsPath
          : (await getApplicationDocumentsDirectory()).path;

      await FlutterDownloader.enqueue(
        url: NetworkConstants.dotnetBotImageUrl,
        savedDir: directory,
        showNotification: true,
        openFileFromNotification: true,
        saveInPublicStorage: true,
      );

      return const Success(true);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
