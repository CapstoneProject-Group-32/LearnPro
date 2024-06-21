// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:LearnPro/Screens/Authentication/authenticate.dart';
// import 'package:LearnPro/Services/auth_firebase.dart';
// import 'package:LearnPro/wrapper.dart';

// class VerificationScreen extends StatefulWidget {
//   const VerificationScreen({super.key});

//   @override
//   State<VerificationScreen> createState() => _VerificationScreenState();
// }

// class _VerificationScreenState extends State<VerificationScreen> {
//   final _auth = AuthServices();
//   late Timer timer;

//   @override
//   void initState() {
//     super.initState();
//     _auth.sendEmailVerificationLink();
//     timer = Timer.periodic(Duration(seconds: 5), (timer) {
//       FirebaseAuth.instance.currentUser?.reload();
//       if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
//         timer.cancel();
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const Wrapper(),
//             ));
//       }
//     });
//   }

//   @override
//   void dispose() {
//     timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Align(
//             alignment: Alignment.center,

//             // padding: const EdgeInsets.symmetric(horizontal: 25),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/verificationbackground.png',
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//                 const SizedBox(height: 20),
//                 const Padding(
//                   padding: EdgeInsets.all(15.0),
//                   child: Text(
//                     "We have sent a verification link to your email. If you didn't receive it, press the resend button below. To log in with a different account, press the back button.",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 25),

// //resend button

//                 GestureDetector(
//                   onTap: () async {
//                     _auth.sendEmailVerificationLink();
//                   },
//                   child: Container(
//                     width: 200,
//                     height: 40,
//                     decoration: ShapeDecoration(
//                       color: Theme.of(context).colorScheme.secondary,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       shadows: const [
//                         BoxShadow(
//                           color: Color(0x3F000000),
//                           blurRadius: 4,
//                           offset: Offset(0, 4),
//                           spreadRadius: 0,
//                         )
//                       ],
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'Re-send',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 17,
//                           fontFamily: 'Work Sans',
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 25),

// //Back button
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const Authenticate()));
//                   },
//                   child: Container(
//                     width: 200,
//                     height: 40,
//                     decoration: ShapeDecoration(
//                       color: Theme.of(context).colorScheme.secondary,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       shadows: const [
//                         BoxShadow(
//                           color: Color(0x3F000000),
//                           blurRadius: 4,
//                           offset: Offset(0, 4),
//                           spreadRadius: 0,
//                         )
//                       ],
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'Back to login',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 17,
//                           fontFamily: 'Work Sans',
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:LearnPro/Screens/Authentication/authenticate.dart';
import 'package:LearnPro/Services/auth_firebase.dart';
import 'package:LearnPro/wrapper.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _auth = AuthServices();
  late Timer timer;
  bool isResending = false;

  @override
  void initState() {
    super.initState();
    _auth.sendEmailVerificationLink();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
        timer.cancel();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Wrapper(),
            ));
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> _resendVerificationEmail() async {
    setState(() {
      isResending = true;
    });
    await _auth.sendEmailVerificationLink();
    setState(() {
      isResending = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verification email re-sent.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/verificationbackground.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "We have sent a verification link to your email. If you didn't receive it, press the resend button below. To log in with a different account, press the back button.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Re-send button
                    GestureDetector(
                      onTap: isResending ? null : _resendVerificationEmail,
                      child: Container(
                        width: 200,
                        height: 40,
                        decoration: ShapeDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Re-send',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Back button
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Authenticate()));
                      },
                      child: Container(
                        width: 200,
                        height: 40,
                        decoration: ShapeDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Back to login',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isResending)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
