import 'package:flutter/widgets.dart';
import 'package:flutter_example/shared/stores/file_store.dart';
import 'package:flutter_example/shared/stores/user_store.dart';

class StoreProvider extends InheritedWidget {
  final FileStore _fileStore;
  final UserStore _userStore;

  FileStore get fileStore => _fileStore;
  UserStore get userStore => _userStore;

  const StoreProvider({
    super.key,
    required super.child,
    required FileStore fileStore,
    required UserStore userStore,
  })  : _fileStore = fileStore,
        _userStore = userStore;

  @override
  bool updateShouldNotify(covariant oldWidget) {
    return false;
  }

  static FileStore getFileStore(BuildContext context) {
    final StoreProvider? result = context.dependOnInheritedWidgetOfExactType<StoreProvider>();
    assert(result != null, 'No NotificationStore found in context');
    return result!.fileStore;
  }

  static UserStore getUserStore(BuildContext context) {
    final StoreProvider? result = context.dependOnInheritedWidgetOfExactType<StoreProvider>();
    assert(result != null, 'No NotificationStore found in context');
    return result!.userStore;
  }
}
