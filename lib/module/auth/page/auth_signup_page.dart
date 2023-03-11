import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_lock_security/data/term/app_term.dart';
import 'package:smart_lock_security/route/app_route.dart';
import 'package:smart_lock_security/widget/widget/stateless_widget/button_stl_widget.dart';
import 'package:smart_lock_security/widget/widget/stateless_widget/sized_box_widget.dart';

import '../../../data/enum/app_state_enum.dart';
import '../../../themes/app_color.dart';
import '../../../themes/app_text_style.dart';
import '../../app_state/repo/app_state_local_storage_repo.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  //text controller
  late TextEditingController _controllerTextEmail;
  late TextEditingController _controllerTextPassword;
  String email = '';
  String password = '';
  bool _passwordVisible = false;

  bool isFullFillEmail = false;
  bool isFullFillPassword = false;
  bool isEmailValid = true;
  bool isSignInPress = false;

  @override
  void dispose() {
    super.dispose();
    _controllerTextPassword.dispose();
    _controllerTextEmail.dispose();
    // _appAuthStateBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controllerTextEmail = TextEditingController(text: email);
    _controllerTextPassword = TextEditingController(text: password);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppAuthTerm.authSignUp),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 40),
                child: Text(
                  AppAuthTerm.createAnAccount,
                  style: AppTextStyle.largeTitle,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: SizedBox(
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 1,
                    // maxLength: 10,
                    autofocus: false,
                    controller: _controllerTextEmail,
                    onChanged: (String contentValue) {
                      debugPrint(contentValue);
                      email = contentValue;
                      if (contentValue.contains('@') &&
                          contentValue.contains('.com')) {
                        setState(() {
                          isEmailValid = true;
                        });
                        debugPrint('Valid email');
                      } else {
                        setState(() {
                          isEmailValid = false;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppFillTextTerm.yourEmail,
                      suffixIcon: IconButton(
                        onPressed: () {
                          _controllerTextEmail.clear();
                          setState(() {
                            isEmailValid = true;
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                ),
              ),
              isEmailValid
                  ? const SizedBox0H()
                  : const Text(
                      AppFillTextTerm.invalidEmail,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontStyle: FontStyle.italic),
                    ),
              Container(
                margin: const EdgeInsets.only(bottom: 10, top: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: SizedBox(
                    child: TextField(
                      // maxLines: (address / 38 ).roundToDouble() + 1,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      maxLength: 10,
                      autofocus: false,
                      controller: _controllerTextPassword,
                      obscureText: !_passwordVisible,
                      onChanged: (String contentValue) {
                        password = contentValue;
                        // debugPrint(smsOtpCode);
                        if (contentValue.length == 10) {
                          setState(
                            () {
                              isFullFillPassword = true;
                            },
                          );
                        } else {
                          setState(
                            () {
                              isFullFillPassword = false;
                            },
                          );
                        }
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: AppFillTextTerm.password,
                        suffixIcon:
                            //  IconButton(
                            //   onPressed: () {
                            //     _controllerTextPassword.clear();
                            //   },
                            //   icon: const Icon(Icons.clear),
                            // ),
                            IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox50H(),
              !isSignInPress
                  ? LongStadiumButton(
                      color: isEmailValid == true && isFullFillPassword == true
                          ? AppColor.pinkAccent
                          : AppColor.light,
                      nameOfButton: AppAuthTerm.authSignUp,
                      onTap: !(isEmailValid == true &&
                              isFullFillPassword == true)
                          ? () {}
                          : () async {
                              FocusScope.of(context).requestFocus(FocusNode());

                              final credential = await signupWithEmail();
                              setState(() {
                                isSignInPress = true;
                              });
                              if (credential == null) {
                                isSignInPress = false;

                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                        'Create account fail, Try again!'),
                                    action: SnackBarAction(
                                      label: 'Ok',
                                      onPressed: () {
                                        // Some code to undo the change.
                                      },
                                    ),
                                  ),
                                );
                              } else {
                                Future.delayed(
                                  const Duration(seconds: 1),
                                  () async {
                                    isSignInPress = false;
                                    await saveAppAuthState(
                                        AppAuthStateEnum.authorized);
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        AppRoute.appNavigatorConfig,
                                        (route) => false);
                                  },
                                );
                              }
                            })
                  : const LongStadiumButtonIndicator(
                      color: AppColor.pinkAccent,
                    )
            ],
          ),
        ),
      ),
    );
  }

  //feature signup with email
  Future<UserCredential?> signupWithEmail() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  //feature check email valid
  bool checkEmailValid(String email) {
    if (email.contains('@') && email.contains('.com')) {
      return true;
    } else {
      return false;
    }
  }
}
