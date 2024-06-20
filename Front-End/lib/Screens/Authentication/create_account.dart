import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Authentication/verification.dart';
import 'package:flutter_application_1/Services/auth_firebase.dart';

import 'package:flutter_application_1/utils/util_functions.dart';
import 'package:flutter_application_1/wrapper.dart';
import 'package:image_picker/image_picker.dart';

class CreateAccount extends StatefulWidget {
  final Function toggle;
  const CreateAccount({Key? key, required this.toggle}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  Uint8List? _profileImage;
  bool isLoading = false;
  final AuthServices _auth = AuthServices();

  String? _profileImageError;
  String? _emailError;
  String? _userNameError;
  String? _majorError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _generalErrorMessage;

  void registerUser() async {
    setState(() {
      _profileImageError =
          _profileImage == null ? "Please upload a profile picture" : null;
      _emailError =
          _emailController.text.isEmpty ? "Email cannot be empty" : null;
      _userNameError =
          _userNameController.text.isEmpty ? "User Name cannot be empty" : null;
      _majorError =
          _majorController.text.isEmpty ? "Major cannot be empty" : null;
      _passwordError = _passwordController.text.isEmpty
          ? "Password cannot be empty"
          : (_passwordController.text.length < 8
              ? "Password must be at least 8 characters long"
              : null);

      _confirmPasswordError = _confirmPassword.text.isEmpty
          ? "Confirm Password cannot be empty"
          : (_confirmPassword.text != _passwordController.text
              ? "Passwords do not match"
              : null);

      _generalErrorMessage = _profileImageError != null ||
              _emailError != null ||
              _userNameError != null ||
              _majorError != null ||
              _passwordError != null ||
              _confirmPasswordError != null
          ? "Please fill all fields correctly"
          : null;
    });

    if (_generalErrorMessage == null) {
      setState(() {
        isLoading = true;
      });

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String major = _majorController.text.trim();
      String userName = _userNameController.text.trim();
      String confirmPassword = _confirmPassword.text.trim();

      String result = await _auth.registerWithEmailAndPassword(
        email: email,
        password: password,
        userName: userName,
        major: major,
        confirmPassword: confirmPassword,
        profilePic: _profileImage!,
      );

      if (result == "email-already-in-use") {
        setState(() {
          _generalErrorMessage = "Email already in use";
        });
      } else if (result == "user-name-already-taken") {
        setState(() {
          _generalErrorMessage = "User name already taken";
        });
      } else if (result == "success") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Wrapper(),
          ),
        );
      } else {
        setState(() {
          _generalErrorMessage = result;
        });
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  void selectImage() async {
    Uint8List profileImage = await pickImage(ImageSource.gallery);
    setState(() {
      _profileImage = profileImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
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
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              _profileImage != null
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.grey[300],
                                      backgroundImage:
                                          MemoryImage(_profileImage!),
                                    )
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.grey[300],
                                      backgroundImage: const AssetImage(
                                          'assets/userIconImage.png'),
                                    ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: IconButton(
                                    onPressed: selectImage,
                                    icon: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (_profileImageError != null)
                        Center(
                          child: Text(
                            _profileImageError!,
                            style: TextStyle(
                              color: Theme.of(context).errorColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email*",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      if (_emailError != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _emailError!,
                            style: TextStyle(
                              color: Theme.of(context).errorColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _userNameController,
                        decoration: InputDecoration(
                          labelText: "User Name*",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      if (_userNameError != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _userNameError!,
                            style: TextStyle(
                              color: Theme.of(context).errorColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _majorController,
                        decoration: InputDecoration(
                          labelText: "Major*",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      if (_majorError != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _majorError!,
                            style: TextStyle(
                              color: Theme.of(context).errorColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password*",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      if (_passwordError != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _passwordError!,
                            style: TextStyle(
                              color: Theme.of(context).errorColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _confirmPassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Confirm Password*",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      if (_confirmPasswordError != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _confirmPasswordError!,
                            style: TextStyle(
                              color: Theme.of(context).errorColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      if (_generalErrorMessage != null)
                        Text(
                          _generalErrorMessage!,
                          style: TextStyle(color: Theme.of(context).errorColor),
                        ),
                      const SizedBox(height: 20),

                      //Register Button

                      GestureDetector(
                        onTap: () async {
                          //calling method for register the user
                          isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.blue,
                                )
                              : registerUser();
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
                              )
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Register',
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
                        height: 30,
                      ),

                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: Color(0xFF092D3F),
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),

                      //Login Button

                      GestureDetector(
                        //method for create account
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
                              )
                            ],
                          ),
                          child: const Center(
                            child: Text(
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
