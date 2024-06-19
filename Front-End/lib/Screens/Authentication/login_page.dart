import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/auth_firebase.dart';
import 'package:flutter_application_1/Widgets/navigation_bar.dart';
import 'package:flutter_application_1/wrapper.dart';

class LoginPage extends StatefulWidget {
  final Function toggle;
  const LoginPage({Key? key, required this.toggle}) : super(key: key);

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
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
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    "Login with Email",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 45),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          errorText: _emailError,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          errorText: _passwordError,
                        ),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          if (!isLoading) loginUser();
                        },
                        child: Container(
                          width: 275,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
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
                          child: Center(
                            child: isLoading
                                ? CircularProgressIndicator(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Work Sans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (_generalErrorMessage != null)
                        Text(
                          _generalErrorMessage!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      const SizedBox(height: 8),
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Color(0xFF092D3F),
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          widget.toggle();
                        },
                        child: Container(
                          width: 275,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
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
                                fontSize: 20,
                                fontFamily: 'Work Sans',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
