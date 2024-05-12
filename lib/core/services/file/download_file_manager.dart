import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter_example/core/interfaces/download_file_manager_interface.dart';
import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/core/services/permission/permission_service.dart';
import 'package:flutter_example/shared/stores/file_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final class DownloadFileManager implements IDownloadFileManager {
  final FileStore _fileStore;

  DownloadFileManager({
    required FileStore fileStore,
  }) : _fileStore = fileStore;

  @override
  Future<Result<bool, Exception>> downloadFile(String fileUrl, String fileName) async {
    final fileId = const Uuid().v4();
    try {
      final addFileToDownloadQueueResult = _fileStore.addFileToDownloadQueue(
        FileStoreModel(
          id: fileId,
          fileName: fileName,
          progress: 0,
        ),
      );
      if (!addFileToDownloadQueueResult) return Failure(Exception('Max concurrent downloads reached'));

      await PermissionService.requestNotificationPermission();

      final directory = Platform.isAndroid
          ? await AndroidPathProvider.downloadsPath
          : (await getApplicationDocumentsDirectory()).path;

      final progressReadPort = ReceivePort();

      await Isolate.spawn(_downloadViaHttp, (fileUrl, fileName, directory, progressReadPort.sendPort));

      await for (final (String fileName, int percentage)? message in progressReadPort) {
        if (message == null) break;

        final fileName = message.$1;
        final progress = message.$2;

        _fileStore.updateProgress(fileId, progress);

        log('Downloading $fileName - $progress%');
      }

      progressReadPort.close();
      return const Success(true);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  static Future<void> _downloadViaHttp(
    (
      String fileUrl,
      String fileName,
      String directory,
      SendPort sendProgressPort,
    ) args,
  ) async {
    final fileUrl = args.$1;
    final fileName = args.$2;
    final directory = args.$3;
    final sendProgressPort = args.$4;


    HttpClient client = HttpClient();

    HttpClientRequest request = await client.getUrl(Uri.parse(fileUrl));
    HttpClientResponse response = await request.close();

    log('Content Length: ${response.contentLength}');

    final uri = Uri.parse(fileUrl);
    final fileExtension = uri.pathSegments.last.split('.').last;

    var filePath = "$directory/$fileName.$fileExtension";

    int version = 1;
    while (await File(filePath).exists()) {
      filePath = "$directory/$fileName($version).$fileExtension";
      version++;
    }

    final savedFile = File(filePath);

    final raf = savedFile.openSync(mode: FileMode.write);

    int readBytes = 0;
    int lastProgress = 0;
    await for (var chunk in response) {
      readBytes += chunk.length;
      
      final progress = (readBytes / response.contentLength * 100).toInt();

      if (lastProgress != progress) {
        lastProgress = progress;
        sendProgressPort.send((fileName, progress));
      }

      await raf.writeFrom(chunk);
    }

    await raf.close();

    log('Total Size Downloaded: $readBytes');

    client.close();

    sendProgressPort.send(null);
  }
}
