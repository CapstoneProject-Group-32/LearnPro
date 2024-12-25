import 'package:LearnPro/Screens/Authentication/authenticate.dart';
import 'package:LearnPro/Screens/Authentication/continuing_registration.dart';
import 'package:LearnPro/Widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:LearnPro/Screens/Authentication/forgot_password_screen.dart';
import 'package:LearnPro/Services/auth_firebase.dart';
import 'package:LearnPro/wrapper.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  final Function toggle;
  const LoginPage({super.key, required this.toggle});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthServices _auth = AuthServices();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  String? _emailError;
  String? _passwordError;
  String? _generalErrorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    Map<SignInStatus, GoogleSignInAccount?> signInStatusMap =
        await _auth.signInWithGoogle(context);
    if (!mounted) return;

    SignInStatus signInStatus = signInStatusMap.keys.first;
    GoogleSignInAccount? googleUser = signInStatusMap.values.first;

    switch (signInStatus) {
      case SignInStatus.canceled:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Authenticate(),
          ),
        );
        break;
      case SignInStatus.registered:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const NavigationBarBottom(),
          ),
        );
        break;
      case SignInStatus.notRegistered:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ContinuingRegistration(googleUser: googleUser),
          ),
        );
        break;
    }

    setState(() {
      isLoading = false;
    });
  }

  void loginUser() async {
    setState(() {
      _emailError =
          _emailController.text.isEmpty ? "Email cannot be empty" : null;
      _passwordError =
          _passwordController.text.isEmpty ? "Password cannot be empty" : null;
      _generalErrorMessage = (_emailError != null || _passwordError != null)
          ? "Please fill all fields correctly"
          : null;
    });

    if (_generalErrorMessage == null) {
      setState(() {
        isLoading = true;
      });

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      String result = await _auth.loginWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return; // Check if the widget is still in the tree

      setState(() {
        isLoading = false;
        _generalErrorMessage = null; // Reset the general error message
        if (result == "Invalid email" || result == "user-not-found") {
          _emailError = "Incorrect email";
          _passwordError = null;
        } else if (result == "wrong-password") {
          _passwordError = "Wrong password";
          _emailError = null;
        } else if (result == "success") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Wrapper()),
          );
        } else {
          _generalErrorMessage = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop(); // Exit the application
        return false; // Prevent further handling of the back button press
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Image.asset(
                        "assets/LearnProLogo_transparent.png",
                        height: 150,
                        width: 150,
                      ),
                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          "Welcome back",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                errorText: _emailError,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                errorText: _passwordError,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Builder(
                                builder: (BuildContext context) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPasswordScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () {
                                if (!isLoading) loginUser();
                              },
                              child: Container(
                                width: 275,
                                height: 50,
                                decoration: ShapeDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 4),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  // child: isLoading
                                  //     ? CircularProgressIndicator(
                                  //         color:
                                  //             Theme.of(context).colorScheme.primary,
                                  //       )
                                  //  :
                                  child: Text(
                                    'Login',
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
                            const SizedBox(height: 32),
                            if (_generalErrorMessage != null)
                              Text(
                                _generalErrorMessage!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 5),
                            GestureDetector(
                              onTap: () {
                                widget.toggle();
                              },
                              child: Container(
                                width: 275,
                                height: 50,
                                decoration: ShapeDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 4),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    'Create a new Account',
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
                            const SizedBox(
                              height: 20,
                            ),
                            const Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 0,
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "OR",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            GestureDetector(
                              onTap: _signInWithGoogle,
                              child: Container(
                                width: 275,
                                height: 50,
                                decoration: ShapeDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 4),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/google.png",
                                      height: 30,
                                      width: 30,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    const Text(
                                      'Continue with Google',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontFamily: 'Work Sans',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
