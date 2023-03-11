import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_lock_security/data/enum/app_state_enum.dart';
import 'package:smart_lock_security/data/term/app_term.dart';
import 'package:smart_lock_security/module/app_state/bloc/app_state_bloc.dart';
import 'package:smart_lock_security/module/app_state/repo/app_state_local_storage_repo.dart';
import 'package:smart_lock_security/module/providers/bloc_provider.dart';
import 'package:smart_lock_security/module/setting/widgets/setting_widget.dart';
import 'package:smart_lock_security/route/app_route.dart';
import 'package:smart_lock_security/themes/app_color.dart';
import 'package:smart_lock_security/widget/widget/stateless_widget/sized_box_widget.dart';

import '../../auth/utils/auth_show_diolog_utils.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  AppThemeBloc? get _appThemeBloc => BlocProvider.of<AppThemeBloc>(context);
  final AppAuthStateBloc _appAuthStateBloc = AppAuthStateBloc();

  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _readThemeModeFromLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox20H(),
            Row(
              children: [
                const SizedBoxW(7),
                Icon(
                  isDarkMode == true ? Icons.dark_mode : Icons.sunny,
                  color: isDarkMode == true
                      ? AppColor.activeStateGrey
                      : AppColor.activeStateYellow,
                ),
                Switch(
                  value: isDarkMode,
                  onChanged: ((value) async {
                    setState(
                      () {
                        isDarkMode = value;
                      },
                    );
                    await _appThemeBloc!
                        .changeAppThemeStateAndEmitStream(value);
                  }),
                )
              ],
            ),
            // SettingActionWidget(
            //   onPressed: () {},
            //   icon: Icons.password,
            //   label: AppAuthTerm.authChangePassword,
            // ),
            //logout
            SettingActionWidget(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                _appAuthStateBloc.logout();
                // ignore: use_build_context_synchronously
                logOutShowMyDialog(context);
              },
              icon: Icons.logout,
              label: AppAuthTerm.authSignOut,
            ),
          ],
        ),
      ),
    );
  }

  //feature: read ThemeMode From LocalStorage
  void _readThemeModeFromLocalStorage() async {
    final readThemeState = await readAppThemeStateFromLocalStorage();
    if (readThemeState == AppThemeStateEnum.dark) {
      setState(() {
        isDarkMode = true;
      });
    } else {
      isDarkMode = false;
    }
  }
}
