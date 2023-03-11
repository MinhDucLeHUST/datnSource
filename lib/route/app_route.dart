import 'package:flutter/material.dart';
import 'package:smart_lock_security/main.dart';
import 'package:smart_lock_security/module/auth/page/auth_page.dart';
import 'package:smart_lock_security/module/auth/page/auth_signin_page.dart';
import 'package:smart_lock_security/navigation/pages/app_navigation.dart';

class AppRoute {
  static const String myApp = '/';
  static const String appNavigatorConfig = '/appNavigatorConfig';
  static const String home = '/home';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String auth = '/auth';
  static const String notification = '/notification';
  static const String personal = '/personal';
  static const String personalUpdateInfor = '/personal-update-information';
  static const String personalDrawer = '/personal-drawer';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case myApp:
        return MaterialPageRoute(
          builder: (_) => const MyApp(),
        );
      case appNavigatorConfig:
        return MaterialPageRoute(
          builder: (_) => const AppNavigationConfig(),
        );

      case signin:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SigninPage(),
        );

      case auth:
        return MaterialPageRoute(
          builder: (BuildContext context) => const AuthPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
