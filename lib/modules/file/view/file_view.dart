import 'package:flutter/material.dart';
import 'package:flutter_example/modules/file/interfaces/file_service_interface.dart';
import 'package:flutter_example/modules/file/mixin/file_mixin.dart';
import 'package:flutter_example/shared/providers/store_provider.dart';
import 'package:flutter_example/shared/stores/file_store.dart';
import 'package:flutter_example/shared/widgets/example_button.dart';
import 'package:signals/signals_flutter.dart';

class FileView extends StatefulWidget {
  final IFileService fileService;

  const FileView({
    super.key,
    required this.fileService,
  });

  @override
  State<FileView> createState() => _FileViewState();
}

class _FileViewState extends State<FileView> with FileMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          ExampleButton(onPressed: downloadFile, text: 'Download Files Concurrently'),
          ExampleButton(onPressed: downloadFileSmall, text: 'Download Small File'),
          ExampleButton(onPressed: downloadFileLarge, text: 'Download Large File'),
          DownloadsListWidget(
            fileStore: StoreProvider.getFileStore(context),
            onItemTapped: openFile,
          ),
        ],
      ),
    );
  }

  @override
  void showMaxDownloadsReachedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Max downloads reached. Please wait for some downloads to complete.'),
      ),
    );
  }
}

class DownloadsListWidget extends StatelessWidget {
  final FileStore fileStore;
  final void Function(String filePath) onItemTapped;

  const DownloadsListWidget({
    super.key,
    required this.fileStore,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: fileStore.fileDownloadQueue.value.length,
        itemBuilder: (context, index) {
          final fileName = fileStore.fileDownloadQueue.value[index].fileName;
          final progress = fileStore.fileDownloadQueue.value[index].progress;
          final path = fileStore.fileDownloadQueue.value[index].path;

          return ListTile(
            onTap: () {
              if (progress == 100 && path != null) {
                onItemTapped(path);
              }
            },
            title: Text(fileName),
            trailing: progress < 100 ? Text('$progress%') : const Icon(Icons.download_done),
          );
        },
      ),
    );
  }
}
