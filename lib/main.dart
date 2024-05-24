import 'package:flutter_example/core/theme/theme.dart';
import 'package:flutter_example/core/theme/util.dart';
import 'package:flutter_example/modules/auth/views/login_view.dart';
import 'package:flutter_example/modules/dog/view/dogs_view.dart';
import 'package:flutter_example/modules/file/view/file_view.dart';
import 'package:flutter_example/modules/home/view/home_view.dart';
import 'package:flutter_example/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example/shared/providers/store_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(
    debug: true,
  );

  await Hive.initFlutter();
  final di = await DependencyInjection.registerServices();

  runApp(MyApp(
    di: di,
  ));
}

class MyApp extends StatelessWidget {
  final GetIt di;
  const MyApp({super.key, required this.di});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");
    MaterialTheme theme = MaterialTheme(textTheme);

    return StoreProvider(
      fileStore: di.get(),
      userStore: di.get(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Caching',
        theme: theme.dark(),
        routerConfig: GoRouter(
          initialLocation: '/login',
          routes: [
            GoRoute(
              path: '/login',
              name: 'login',
              builder: (context, state) => const LoginView(),
            ),
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) {
                return HomeView(
                  homeService: di.get(),
                );
              },
            ),
            GoRoute(
              path: '/file',
              name: 'file',
              builder: (context, state) {
                return FileView(
                  fileService: di.get(),
                );
              },
            ),
            GoRoute(
              path: '/dogs',
              name: 'dogs',
              builder: (context, state) {
                return DogsView(
                  dogService: di.get(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
