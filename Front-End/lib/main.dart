import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/Models/usermodel.dart';
import 'package:flutter_application_1/Services/auth_firebase.dart';
import 'package:flutter_application_1/theme/dark_theme.dart';
import 'package:flutter_application_1/theme/light_theme.dart';
import 'package:flutter_application_1/wrapper.dart';
import 'package:provider/provider.dart';

import 'Flashcards/generate_flashcard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GenerateFlashcard()),
      ],
      child: const MyApp(),
    ),
  );
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: const Wrapper(),
      ),
    );
  }
}
