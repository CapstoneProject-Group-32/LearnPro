import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Authentication/create_account.dart';
import 'package:flutter_application_1/Screens/Authentication/login_page.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool loginPage = true;

  // toggle pages

  void switchPages() {
    setState(() {
      loginPage = !loginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loginPage == true) {
      return LoginPage(toggle: switchPages);
    } else {
      return CreateAccount(toggle: switchPages);
    }
  }
}
