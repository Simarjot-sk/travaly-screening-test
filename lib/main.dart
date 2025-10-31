import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travaly/data/repo/device_info_repo.dart';
import 'package:travaly/data/repo/travaly_repo.dart';
import 'package:travaly/features/auth/auth_page.dart';
import 'package:travaly/theme/themes.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initFirebase();
  runApp(Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => _initDio()),
        RepositoryProvider(create: (_) => DeviceInfoRepo()),
        RepositoryProvider(
          create: (context) =>
              TravalyRepo(dio: context.read(), deviceInfoRepo: context.read()),
        ),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.system,
        darkTheme: createTheme(context, Brightness.dark),
        theme: createTheme(context, Brightness.light),
        home: AuthPage(),
      ),
    );
  }
}

Future<void> _initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Dio _initDio() {
  final options = BaseOptions(
    baseUrl: 'https://api.mytravaly.com/public/v1/',
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
  );
  final dio = Dio(options);
  dio.interceptors.addAll([
    LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
    ),
  ]);
  return dio;
}
