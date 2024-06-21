import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/Screens/Authentication/authenticate.dart';
import 'package:flutter_application_1/Screens/Authentication/verification.dart';
import 'package:flutter_application_1/Widgets/navigation_bar.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  //@override
  // Widget build(BuildContext context) {
  //   //the user data that the provider proides this can be a user data or can be null.

  //   final user = Provider.of<UserModel?>(context);
  //   if (user == null) {
  //     return const Authenticate();
  //   } else {
  //     return const NavigationBarBottom();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          } else {
            if (snapshot.data == null) {
              return const Authenticate();
            } else {
              if (snapshot.data?.emailVerified == true) {
                return const NavigationBarBottom();
              }
              return const VerificationScreen();
            }
          }
        },
      ),
    );
  }
}
