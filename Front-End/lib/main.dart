import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/Models/usermodel.dart';

import 'package:flutter_application_1/Services/auth_firebase.dart';

import 'package:flutter_application_1/choosing_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      value: AuthServices().user,
      initialData: UserModel(
        uid: "",
        email: '',
        userName: '',
        major: '',
        profilePic: '',
        friends: [],
      ),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}
