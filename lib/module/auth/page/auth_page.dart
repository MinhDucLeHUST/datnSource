import 'package:flutter/material.dart';
import 'package:smart_lock_security/data/term/app_term.dart';
import 'package:smart_lock_security/module/auth/page/auth_signin_page.dart';
import 'package:smart_lock_security/themes/app_color.dart';
import 'package:smart_lock_security/themes/app_text_style.dart';
import 'package:smart_lock_security/widget/widget/stateless_widget/button_stl_widget.dart';
import 'package:unicons/unicons.dart';

import '../utils/auth_show_diolog_utils.dart';
import '../widget/auth_widget.dart';
import 'auth_signup_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTerm.appName,
          style: AppTextStyle.appName
              .copyWith(fontStyle: FontStyle.italic, fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 60, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/app_logo.png',
                    height: 100,
                    width: 100,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                AppTerm.appNameFull,
                style: AppTextStyle.h2.copyWith(fontSize: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Text(
                AppTerm.appDescription,
                style:
                    AppTextStyle.body17.copyWith(fontWeight: FontWeight.w300),
              ),
            ),

            //LOGIN Button
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              padding: const EdgeInsets.only(top: 20, bottom: 5),
              child: LongStadiumButton(
                color: AppColor.pinkAccent,
                nameOfButton: AppAuthTerm.authSignIn,
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SigninPage(),
                    ),
                  );
                  // Navigator.of(context).pushNamed(AppRoute.signin);
                },
              ),
            ),

            //SIGNIN Button
            LongStadiumButton(
              nameOfButton: AppAuthTerm.authSignUp,
              onTap: () async {
                // ignore: avoid_print
                // print('Press sign up');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const SignupPage()),
                  ),
                );
                // final String? fcmToken = await getFcmTokenFromLocalStorage();
                // ignore: avoid_print
                // print('fcmToken: $fcmToken');
              },
            ),
            const SizedBox(
              height: 48,
            ),
            Text(
              'Or sign in with',
              style: AppTextStyle.caption13.copyWith(
                color: AppTextColor.grey,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconLoginOptional(
                  icon: UniconsLine.facebook,
                  onTap: () {
                    debugPrint('Press fb');
                    showMyDialogAuth(context);
                  },
                ),
                IconLoginOptional(
                  icon: UniconsLine.twitter,
                  onTap: () {
                    debugPrint('Press twitter');
                    showMyDialogAuth(context);
                  },
                ),
                IconLoginOptional(
                  icon: UniconsLine.google,
                  // onTap: () async {
                  //   bool loginStatus =
                  //       await LoginWithDofhuntAPI.loginWithDofhuntAPI();

                  //   if (loginStatus) {
                  //     _changeAppState();
                  //   }
                  // },
                  onTap: () {
                    debugPrint('Press google');
                    showMyDialogAuth(context);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }
}
