import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakaranai/ui/app_view.dart';

import 'blocs/auth/authentication_cubit.dart';
import 'blocs/configs/configs_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static final navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState? get navigator => navigatorKey.currentState;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          lazy: false,
          create: (context) =>
              AuthenticationCubit()..authorize('armatura@gmail.com', '1234')),
      BlocProvider<ConfigsCubit>(
        create: (context) => ConfigsCubit()..getConfigs(),
      )
    ], child: const AppView());
  }
}
