import 'package:flutter/material.dart';
import 'package:smart_lock_security/data/enum/app_state_enum.dart';
import 'package:smart_lock_security/module/app_state/bloc/app_state_bloc.dart';
import 'package:smart_lock_security/module/auth/page/auth_page.dart';
import 'package:smart_lock_security/module/providers/bloc_provider.dart';
import 'package:smart_lock_security/navigation/pages/app_navigation.dart';
import 'package:smart_lock_security/route/app_route.dart';
import 'package:smart_lock_security/themes/app_font.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Firebase initial
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final _appStateStreamControllerBloc = AppThemeBloc();
  final _appAuthStateStreamControllerBloc = AppAuthStateBloc();

  @override
  void dispose() {
    super.dispose();
    _appAuthStateStreamControllerBloc.dispose();
    _appStateStreamControllerBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _appStateStreamControllerBloc,
      child: StreamBuilder<AppThemeStateEnum>(
        stream: _appStateStreamControllerBloc.stream,
        builder: (context, snapshot) {
          return MaterialApp(
            onGenerateRoute: AppRoute.generateRoute,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              brightness: snapshot.data == AppThemeStateEnum.light
                  ? Brightness.light
                  : Brightness.dark,
              // primarySwatch: Colors.blue,
              fontFamily: AppFont.avenir,
              primaryColor: Colors.pink,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
              ),
            ),
            // home: const MyHomePage(),
            home: BlocProvider(
              bloc: _appAuthStateStreamControllerBloc,
              child: StreamBuilder<AppAuthStateEnum>(
                stream: _appAuthStateStreamControllerBloc.appAuthStateStream,
                initialData: _appAuthStateStreamControllerBloc.initAppAuthState,
                builder: ((context, snapshot) {
                  if (snapshot.data == AppAuthStateEnum.authorized) {
                    return const AppNavigationConfig();
                  } else if (snapshot.data == AppAuthStateEnum.unAuthorized) {
                    return BlocProvider(
                      bloc: _appAuthStateStreamControllerBloc,
                      child: const AuthPage(),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                    // child: AppNavigationConfig(),
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const AuthPage();
  }
}
