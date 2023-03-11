import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smart_lock_security/module/home/model/realtime_database_model.dart';
import 'package:smart_lock_security/module/home/widgets/home_widget.dart';
import 'package:smart_lock_security/themes/app_color.dart';
import 'package:smart_lock_security/widget/widget/stateless_widget/sized_box_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //firebase realtime_database
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref("mac");
  // StreamController<DatabaseEvent> databaseStreamController =
  //     StreamController<DatabaseEvent>();

  late Stream<DatabaseEvent> databaseStream;

  //text form editing
  late TextEditingController _controllerCurrentLockPassword;
  late TextEditingController _controllerNewLockPassword;
  late TextEditingController _controllerConfirmNewLockPassword;
  String currentLockPassword = '123456';
  String newLockPassword = '';
  String confirmNewLockPassword = '';
  bool isOpen = false;
  bool isAntiThief = false;
  bool isWarning = false;
  RealtimeDatebaseModel dataFromRealtimeDatabase = RealtimeDatebaseModel(
    hasCameraRequest: false,
    isAntiThief: false,
    isOpen: false,
    isWarning: false,
    password: '',
  );

  @override
  void initState() {
    super.initState();
    setStateImageUrl();
    _controllerCurrentLockPassword = TextEditingController(text: '');
    _controllerNewLockPassword = TextEditingController(text: '');
    _controllerConfirmNewLockPassword = TextEditingController(text: '');
    databaseStream = databaseRef.onValue.asBroadcastStream();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerNewLockPassword.dispose();
    _controllerConfirmNewLockPassword.dispose();
    _controllerCurrentLockPassword.dispose();
    databaseRef.onValue.listen((event) {}).cancel();
    databaseStream.listen((event) {}).cancel();
  }

  bool isSameCurrentPassword = false;
  bool isSameNewPassword = false;
  bool isCurrentPasswordHide = true;
  bool isNewPasswordHide = true;
  bool isConfirmNewPasswordHide = true;
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    databaseStream.listen((event) {
      final dataFromRealtimeDatabaseJson =
          event.snapshot.value as Map<dynamic, dynamic>;

      setState(() {
        dataFromRealtimeDatabase =
            RealtimeDatebaseModel.fromJson(dataFromRealtimeDatabaseJson);
      });
      Future.delayed(const Duration(seconds: 0), (() async {
        if (dataFromRealtimeDatabase.hasCameraRequest == true) {
          await setStateImageUrl();
        }
      }));
    });
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final height = screenSize.height;

    return Scaffold(
      appBar: AppBar(title: const Text('HomePage')),
      body: SizedBox(
        height: height,
        child: Column(
          children: [
            Container(
              width: screenWidth,
              color: AppColor.lightGrey1,
              child: Image.network(
                imageUrl ??
                    'https://www.namepros.com/attachments/empty-png.89209/',
                height: 230,
                fit: BoxFit.fitWidth,
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisSpacing: 10,
                // mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: [
                  //lock/unlock
                  HomePageFeatureActionWidget(
                    actionFuntion: () {
                      updateIsOpen(isOpen: !dataFromRealtimeDatabase.isOpen);
                    },
                    actionState: !dataFromRealtimeDatabase.isOpen,
                    icon: dataFromRealtimeDatabase.isOpen
                        ? const Icon(Icons.lock_open)
                        : const Icon(Icons.lock_outline),
                    title: dataFromRealtimeDatabase.isOpen
                        ? 'Lock: OFF'
                        : 'Lock: ON',
                  ),
                  //camera
                  HomePageFeatureActionWidget(
                    actionFuntion: () async {
                      if (dataFromRealtimeDatabase.hasCameraRequest == true) {
                        hasCameraRequest(hasCameraRequest: false);
                      } else {
                        hasCameraRequest(hasCameraRequest: true);
                        await setStateImageUrl();
                        Future.delayed(const Duration(seconds: 2), () async {
                          hasCameraRequest(hasCameraRequest: false);
                        });
                      }
                    },
                    actionState: dataFromRealtimeDatabase.hasCameraRequest,
                    icon: const Icon(Icons.photo_camera),
                    title: 'Camera',
                  ),
                  //home safety
                  HomePageFeatureActionWidget(
                    actionFuntion: () {
                      updateIsAntiThief(
                          isAntiThief: !dataFromRealtimeDatabase.isAntiThief);
                    },
                    actionState: dataFromRealtimeDatabase.isAntiThief,
                    icon: dataFromRealtimeDatabase.isAntiThief
                        ? const Icon(Icons.home)
                        : const Icon(Icons.home_outlined),
                    title: dataFromRealtimeDatabase.isAntiThief
                        ? 'Home safety: ON'
                        : 'Home safety: OFF',
                  ),
                  //isWarning
                  HomePageFeatureActionWidget(
                    actionFuntion: () {
                      updateWarningState(
                          isWarning: !dataFromRealtimeDatabase.isWarning);
                    },
                    colorAction: AppColor.warningYellow,
                    actionState: dataFromRealtimeDatabase.isWarning,
                    icon: dataFromRealtimeDatabase.isWarning
                        ? const Icon(Icons.warning)
                        : const Icon(Icons.warning_amber_outlined),
                    title: dataFromRealtimeDatabase.isWarning
                        ? 'Warning : ON'
                        : 'Warning: OFF',
                  ),
                  //change lock password
                  HomePageFeatureActionWidget(
                    actionFuntion: () {
                      showChangePasswordFormDialog(context: context);
                    },
                    actionState: false,
                    icon: const Icon(Icons.password),
                    title: 'Change Password',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //feature : update lock password
  void updateLockPassword() async {
    await databaseRef.update(
      {"password": newLockPassword.toString()},
    );
  }

  //feature : update open state
  void updateIsOpen({required bool isOpen}) async {
    await databaseRef.update(
      {"isOpen": isOpen},
    );
  }

  //feature : update antithief state
  void updateIsAntiThief({required bool isAntiThief}) async {
    await databaseRef.update(
      {"isAntiThief": isAntiThief},
    );
  }

  //feature : update warning state
  void updateWarningState({required bool isWarning}) async {
    await databaseRef.update(
      {"isWarning": isWarning},
    );
  }

  //feature : update camera request state
  void hasCameraRequest({required bool hasCameraRequest}) async {
    await databaseRef.update(
      {"hasCameraRequest": hasCameraRequest},
    );
  }

  //feature : show Change Password Form Dialog
  void showChangePasswordFormDialog({required BuildContext context}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Change Lock Password'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    //current password
                    TextFormField(
                      controller: _controllerCurrentLockPassword,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      obscureText: isCurrentPasswordHide,
                      decoration: const InputDecoration(
                        labelText: 'Current password',
                        icon: Icon(Icons.password),
                      ),
                      onChanged: (value) {
                        if (value == currentLockPassword) {
                          setState(() {
                            isSameCurrentPassword = true;
                          });
                        }
                      },
                    ),

                    //new password
                    TextFormField(
                      controller: _controllerNewLockPassword,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      obscureText: isNewPasswordHide,
                      decoration: const InputDecoration(
                        labelText: 'New password',
                        icon: Icon(Icons.password),
                      ),
                      onChanged: (value) {
                        setState(() {
                          newLockPassword = value;
                        });
                      },
                    ),

                    //confirm new password
                    TextFormField(
                      controller: _controllerConfirmNewLockPassword,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      obscureText: isConfirmNewPasswordHide,
                      decoration: const InputDecoration(
                        labelText: 'Confirm new password',
                        icon: Icon(Icons.password),
                      ),
                      onChanged: (value) {
                        confirmNewLockPassword = value;
                        if (newLockPassword == value) {
                          isSameNewPassword = true;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                  child: const Text("Submit"),
                  onPressed: () {
                    // your code
                    Navigator.pop(context);
                    if (isSameNewPassword) {
                      updateLockPassword();
                      Future.delayed(const Duration(seconds: 1), () {
                        showSnackBarChangePasswordDone();
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Password does not match'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: const <Widget>[
                                  Text('Please enter the same new password'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                  onPressed: () async {
                                    await navigatorPopDialogAsycn(context);
                                    showChangePasswordFormDialog(
                                        context: context);
                                  },
                                  child: const Text('Try again'))
                            ],
                          );
                        },
                      );
                    }
                    _controllerConfirmNewLockPassword.clear();
                    _controllerCurrentLockPassword.clear();
                    _controllerNewLockPassword.clear();
                  })
            ],
          );
        });
  }

  //feature : show SnackBar when change Password Done
  void showSnackBarChangePasswordDone() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Change lock password successful'),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      ),
    );
  }

  Future<void> navigatorPopDialogAsycn(BuildContext context) async {
    Navigator.of(context).pop();
  }

  //feature: get url image from firebase storage
  Future<String?> getImage() async {
    final ref = FirebaseStorage.instance.ref().child("data");
    final List<dynamic> fileRefs = (await ref.listAll()).items;

    final String url = (await fileRefs.first.getDownloadURL()).toString();

    print('url: $url');
    return url;
  }

  //feature: set imageUrl to widget State for ShowImage
  Future<void> setStateImageUrl() async {
    String? url = await getImage();
    if (url != null) {
      setState(() {
        imageUrl = url;
      });
    }
    debugPrint('Url when have event: $url');
  }
}
