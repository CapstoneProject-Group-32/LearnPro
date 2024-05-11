import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/home_page.dart';
import 'package:flutter_application_1/Services/auth_firebase.dart';
import 'package:flutter_application_1/utils/util_functions.dart';

class LoginPage extends StatefulWidget {
  //function
  final Function toggle;
  const LoginPage({Key? key, required this.toggle}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
//ref for the class

  final AuthServices _auth = AuthServices();

//form key

  final _formKey = GlobalKey<FormState>();

  //controllers for the text feilds
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoaging = false;

  //this  dispose methode is for remove the controller data from the memory
  void dispose() {
    super.dispose();
    //dispose the controllers
    _emailController.dispose();
    _passwordController.dispose();
  }

  //login the user
  void loginUser() async {
    setState(() {
      isLoaging = true;
    });
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    String result = await _auth.loginWithEmailAndPassword(
      email: email,
      password: password,
    );

    //show the snak bar if the user is created or not

    if (result == "email-already-in-use" ||
        result == "weak-password" ||
        result == "invalid-email") {
      showSnakBar(context, result);
    } else if (result == 'success') {
      //here the pushReplacement is used for remove the back button from the screen

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }

    setState(() {
      isLoaging = false;
    });

    print("user logged in");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  "assets/LearnProLogo.jpg",
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    "Login with Email",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF051A85),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
//e-mail

                      TextFormField(
                        controller: _emailController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: const TextStyle(
                            color: Color(0xFF16697A),
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF16697A),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),

//Password

                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(
                            color: Color(0xFF16697A),
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF16697A),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),

//login button

                      GestureDetector(
                        onTap: () {
//calling methode for login user
                          isLoaging
                              ? const CircularProgressIndicator(
                                  color: Colors.blue,
                                )
                              : loginUser();
                        },
                        child: Container(
                          width: 275,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF29F6D2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
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
                              'Login',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontFamily: 'Work Sans',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      const Text(
                        "Don't have an account?",
                        style:
                            TextStyle(color: Color(0xFF092D3F), fontSize: 20),
                      ),
                      const SizedBox(
                        height: 8,
                      ),

//create a new account button

                      GestureDetector(
                        //methode for login user
                        onTap: () {
                          widget.toggle();
                        },
                        child: Container(
                          width: 275,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF29F6D2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
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
                              'Create a new Accoumt',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
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

                      const Center(
                        child: Text(
                          "Or",
                          style:
                              TextStyle(color: Color(0xFF092D3F), fontSize: 20),
                        ),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

//Login as Guest

                      GestureDetector(
                        //method for create account
                        onTap: () async {
                          dynamic result = await _auth.logInAnonymously();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                          if (result == Null) {
                            print("error in login");
                          } else {
                            print("log in Anonymously");
                          }
                        },
                        child: Container(
                          width: 275,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                              side: const BorderSide(
                                width: 2,
                                color: Color(0xFF29F6D2),
                              ),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Login as Guest',
                              style: TextStyle(
                                color: Color(0xFF29F6D2),
                                fontSize: 25,
                                fontFamily: 'Work Sans',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
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
