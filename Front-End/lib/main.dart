import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:LearnPro/Models/usermodel.dart';
import 'package:LearnPro/Services/auth_firebase.dart';
import 'package:LearnPro/theme/dark_theme.dart';
import 'package:LearnPro/theme/light_theme.dart';
import 'package:LearnPro/wrapper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'Flashcards/generate_flashcard.dart';
import 'Quiz/quiz_controler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  try {
    await Firebase.initializeApp();
    await dotenv.load(fileName: ".env");
    debugPrint("done loading file");
  } catch (e) {
    print('Error initializing app: $e');
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GenerateFlashcard()),
        ChangeNotifierProvider(create: (_) => QuizController()),
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
