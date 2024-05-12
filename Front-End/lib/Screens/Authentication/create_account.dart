import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_application_1/Services/auth_firebase.dart';
import 'package:flutter_application_1/Widgets/navigation_bar.dart';
import 'package:flutter_application_1/utils/util_functions.dart';
import 'package:image_picker/image_picker.dart';

class CreateAccount extends StatefulWidget {
  //function
  final Function toggle;
  const CreateAccount({Key? key, required this.toggle}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  //controllers for the text feilds

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  Uint8List? _profileImage;
  bool isLoading = false;
  final AuthServices _auth = AuthServices();

  //register the user

  void registerUser() async {
    setState(() {
      isLoading = true;
    });

    //get the user data from the text feilds

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String major = _majorController.text.trim();
    String userName = _userNameController.text.trim();
    String confirmPassword = _confirmPassword.text.trim();

    //register the user

    String result = await _auth.registerWithEmailAndPassword(
      email: email,
      password: password,
      userName: userName,
      major: major,
      confirmPassword: confirmPassword,
      profilePic: _profileImage!,
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
        MaterialPageRoute(
          builder: (context) => const NavigationBarBottom(),
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

//this methode is for select the image from the gallery

  void selectImage() async {
    Uint8List _profileImage = await pickImage(ImageSource.gallery);
    setState(() {
      this._profileImage = _profileImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  "assets/LearnProLogo.jpg",
                  height: 200,
                  width: 200,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Center(
                  child: Text(
                    "Create an Account",
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

                //add a profile image

                Stack(
                  children: [
                    //if the profile image is null show the default image
                    _profileImage != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: MemoryImage(_profileImage!),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            backgroundImage:
                                const AssetImage('assets/userIconImage.png'),
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
                            color: Colors.yellow.shade600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),

                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
//e-mail

                      TextFormField(
                        controller: _emailController,
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

//User Name

                      TextFormField(
                        controller: _userNameController,
                        decoration: InputDecoration(
                          labelText: "User Name",
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

//Major

                      TextFormField(
                        controller: _majorController,
                        decoration: InputDecoration(
                          labelText: "Major",
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

//Confirm Password

                      TextFormField(
                        controller: _confirmPassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
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
                              'Register',
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
                        "Already have an account?",
                        style:
                            TextStyle(color: Color(0xFF092D3F), fontSize: 20),
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
                              'Login',
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
