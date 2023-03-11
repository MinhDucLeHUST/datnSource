import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_lock_security/module/home/page/home_page.dart';
import 'package:smart_lock_security/module/setting/page/setting_page.dart';

import '../../../themes/app_color.dart';

class AppNavigationConfig extends StatefulWidget {
  final bool? navigateKeyPersonal;
  const AppNavigationConfig({this.navigateKeyPersonal, Key? key})
      : super(key: key);

  @override
  State<AppNavigationConfig> createState() => _AppNavigationConfigState();
}

class _AppNavigationConfigState extends State<AppNavigationConfig> {
  // NotificationBlocStream get _notificationBlocStream =>
  //     BlocProvider.of<NotificationBlocStream>(context)!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).brightness;

    return CupertinoTabScaffold(
      // backgroundColor: AppColor.greyBold,
      tabBar: CupertinoTabBar(
        currentIndex: 0,
        activeColor: AppColor.pinkAccent,
        inactiveColor:
            themeData == Brightness.dark ? AppColor.grey : AppColor.dark,
        backgroundColor:
            themeData == Brightness.dark ? AppColor.dark : AppColor.lightGrey1,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) {
                return const CupertinoPageScaffold(
                  child: HomePage(),
                );
              },
            );

          case 1:
            return CupertinoTabView(
              builder: (context) {
                return const CupertinoPageScaffold(
                  child: SettingPage(),
                );
              },
            );

          default:
            return CupertinoTabView(
              builder: (context) {
                return const CupertinoPageScaffold(
                  child: HomePage(),
                );
              },
            );
        }
      },
    );
  }
}
