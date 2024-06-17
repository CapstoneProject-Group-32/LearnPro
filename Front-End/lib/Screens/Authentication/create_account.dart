// // // import 'dart:typed_data';

// // // import 'package:flutter/material.dart';

// // // import 'package:flutter_application_1/Services/auth_firebase.dart';
// // // import 'package:flutter_application_1/Widgets/navigation_bar.dart';
// // // import 'package:flutter_application_1/utils/util_functions.dart';
// // // import 'package:image_picker/image_picker.dart';

// // // class CreateAccount extends StatefulWidget {
// // //   //function
// // //   final Function toggle;
// // //   const CreateAccount({Key? key, required this.toggle}) : super(key: key);

// // //   @override
// // //   State<CreateAccount> createState() => _CreateAccountState();
// // // }

// // // class _CreateAccountState extends State<CreateAccount> {
// // //   //controllers for the text feilds

// // //   final TextEditingController _emailController = TextEditingController();
// // //   final TextEditingController _passwordController = TextEditingController();
// // //   final TextEditingController _majorController = TextEditingController();
// // //   final TextEditingController _userNameController = TextEditingController();
// // //   final TextEditingController _confirmPassword = TextEditingController();
// // //   Uint8List? _profileImage;
// // //   bool isLoading = false;
// // //   final AuthServices _auth = AuthServices();

// // //   //register the user

// // //   void registerUser() async {
// // //     setState(() {
// // //       isLoading = true;
// // //     });

// // //     //get the user data from the text feilds

// // //     String email = _emailController.text.trim();
// // //     String password = _passwordController.text.trim();
// // //     String major = _majorController.text.trim();
// // //     String userName = _userNameController.text.trim();
// // //     String confirmPassword = _confirmPassword.text.trim();

// // //     //register the user

// // //     String result = await _auth.registerWithEmailAndPassword(
// // //       email: email,
// // //       password: password,
// // //       userName: userName,
// // //       major: major,
// // //       confirmPassword: confirmPassword,
// // //       profilePic: _profileImage!,
// // //     );

// // //     //show the snak bar if the user is created or not

// // //     if (result == "email-already-in-use" ||
// // //         result == "weak-password" ||
// // //         result == "invalid-email") {
// // //       showSnakBar(context, result);
// // //     } else if (result == 'success') {
// // //       //here the pushReplacement is used for remove the back button from the screen

// // //       Navigator.pushReplacement(
// // //         context,
// // //         MaterialPageRoute(
// // //           builder: (context) => const NavigationBarBottom(),
// // //         ),
// // //       );
// // //     }
// // //     setState(() {
// // //       isLoading = false;
// // //     });
// // //   }

// // // //this methode is for select the image from the gallery

// // //   void selectImage() async {
// // //     Uint8List profileImage = await pickImage(ImageSource.gallery);
// // //     setState(() {
// // //       _profileImage = profileImage;
// // //     });
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return SafeArea(
// // //       child: Scaffold(
// // //         backgroundColor: Colors.white,
// // //         body: Padding(
// // //           padding: const EdgeInsets.all(40.0),
// // //           child: SingleChildScrollView(
// // //             child: Column(
// // //               children: [
// // //                 const SizedBox(height: 30),
// // //                 Image.asset(
// // //                   "assets/LearnProLogo.jpg",
// // //                   height: 200,
// // //                   width: 200,
// // //                 ),
// // //                 const SizedBox(
// // //                   height: 30,
// // //                 ),
// // //                 const Center(
// // //                   child: Text(
// // //                     "Create an Account",
// // //                     style: TextStyle(
// // //                       fontSize: 40,
// // //                       fontWeight: FontWeight.w500,
// // //                       color: Color(0xFF051A85),
// // //                     ),
// // //                   ),
// // //                 ),

// // //                 const SizedBox(
// // //                   height: 45,
// // //                 ),

// // //                 //add a profile image

// // //                 Stack(
// // //                   children: [
// // //                     //if the profile image is null show the default image
// // //                     _profileImage != null
// // //                         ? CircleAvatar(
// // //                             radius: 50,
// // //                             backgroundColor: Colors.grey[300],
// // //                             backgroundImage: MemoryImage(_profileImage!),
// // //                           )
// // //                         : CircleAvatar(
// // //                             radius: 50,
// // //                             backgroundColor: Colors.grey[300],
// // //                             backgroundImage:
// // //                                 const AssetImage('assets/userIconImage.png'),
// // //                           ),

// // //                     Positioned(
// // //                       bottom: 0,
// // //                       right: 0,
// // //                       child: Container(
// // //                         height: 40,
// // //                         width: 40,
// // //                         decoration: BoxDecoration(
// // //                           color: Colors.white70,
// // //                           borderRadius: BorderRadius.circular(30),
// // //                         ),
// // //                         child: IconButton(
// // //                           onPressed: selectImage,
// // //                           icon: Icon(
// // //                             Icons.add_a_photo,
// // //                             color: Colors.grey[300],
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),

// // //                 const SizedBox(
// // //                   height: 30,
// // //                 ),

// // //                 Form(
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.stretch,
// // //                     children: [
// // // //e-mail

// // //                       TextFormField(
// // //                         controller: _emailController,
// // //                         decoration: InputDecoration(
// // //                           labelText: "Email",
// // //                           labelStyle: const TextStyle(
// // //                             color: Color(0xFF16697A),
// // //                             fontSize: 20,
// // //                             fontWeight: FontWeight.w400,
// // //                           ),
// // //                           border: OutlineInputBorder(
// // //                             borderRadius: BorderRadius.circular(5),
// // //                           ),
// // //                           focusedBorder: const OutlineInputBorder(
// // //                             borderSide: BorderSide(
// // //                               color: Color(0xFF16697A),
// // //                               width: 2,
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       const SizedBox(
// // //                         height: 30,
// // //                       ),

// // // //User Name

// // //                       TextFormField(
// // //                         controller: _userNameController,
// // //                         decoration: InputDecoration(
// // //                           labelText: "User Name",
// // //                           labelStyle: const TextStyle(
// // //                             color: Color(0xFF16697A),
// // //                             fontSize: 20,
// // //                             fontWeight: FontWeight.w400,
// // //                           ),
// // //                           border: OutlineInputBorder(
// // //                             borderRadius: BorderRadius.circular(5),
// // //                           ),
// // //                           focusedBorder: const OutlineInputBorder(
// // //                             borderSide: BorderSide(
// // //                               color: Color(0xFF16697A),
// // //                               width: 2,
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),

// // //                       const SizedBox(
// // //                         height: 30,
// // //                       ),

// // // //Major

// // //                       TextFormField(
// // //                         controller: _majorController,
// // //                         decoration: InputDecoration(
// // //                           labelText: "Major",
// // //                           labelStyle: const TextStyle(
// // //                             color: Color(0xFF16697A),
// // //                             fontSize: 20,
// // //                             fontWeight: FontWeight.w400,
// // //                           ),
// // //                           border: OutlineInputBorder(
// // //                             borderRadius: BorderRadius.circular(5),
// // //                           ),
// // //                           focusedBorder: const OutlineInputBorder(
// // //                             borderSide: BorderSide(
// // //                               color: Color(0xFF16697A),
// // //                               width: 2,
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       const SizedBox(
// // //                         height: 30,
// // //                       ),

// // // //Password

// // //                       TextFormField(
// // //                         controller: _passwordController,
// // //                         obscureText: true,
// // //                         decoration: InputDecoration(
// // //                           labelText: "Password",
// // //                           labelStyle: const TextStyle(
// // //                             color: Color(0xFF16697A),
// // //                             fontSize: 20,
// // //                             fontWeight: FontWeight.w400,
// // //                           ),
// // //                           border: OutlineInputBorder(
// // //                             borderRadius: BorderRadius.circular(5),
// // //                           ),
// // //                           focusedBorder: const OutlineInputBorder(
// // //                             borderSide: BorderSide(
// // //                               color: Color(0xFF16697A),
// // //                               width: 2,
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       const SizedBox(
// // //                         height: 30,
// // //                       ),

// // // //Confirm Password

// // //                       TextFormField(
// // //                         controller: _confirmPassword,
// // //                         obscureText: true,
// // //                         decoration: InputDecoration(
// // //                           labelText: "Confirm Password",
// // //                           labelStyle: const TextStyle(
// // //                             color: Color(0xFF16697A),
// // //                             fontSize: 20,
// // //                             fontWeight: FontWeight.w400,
// // //                           ),
// // //                           border: OutlineInputBorder(
// // //                             borderRadius: BorderRadius.circular(5),
// // //                           ),
// // //                           focusedBorder: const OutlineInputBorder(
// // //                             borderSide: BorderSide(
// // //                               color: Color(0xFF16697A),
// // //                               width: 2,
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       const SizedBox(
// // //                         height: 30,
// // //                       ),

// // // //Register Button

// // //                       GestureDetector(
// // //                         onTap: () async {
// // // //calling method for register the user
// // //                           isLoading
// // //                               ? const CircularProgressIndicator(
// // //                                   color: Colors.blue,
// // //                                 )
// // //                               : registerUser();
// // //                         },
// // //                         child: Container(
// // //                           width: 275,
// // //                           height: 50,
// // //                           decoration: ShapeDecoration(
// // //                             color: const Color(0xFF29F6D2),
// // //                             shape: RoundedRectangleBorder(
// // //                               borderRadius: BorderRadius.circular(35),
// // //                             ),
// // //                             shadows: const [
// // //                               BoxShadow(
// // //                                 color: Color(0x3F000000),
// // //                                 blurRadius: 4,
// // //                                 offset: Offset(0, 4),
// // //                                 spreadRadius: 0,
// // //                               )
// // //                             ],
// // //                           ),
// // //                           child: const Center(
// // //                             child: Text(
// // //                               'Register',
// // //                               style: TextStyle(
// // //                                 color: Colors.black,
// // //                                 fontSize: 25,
// // //                                 fontFamily: 'Work Sans',
// // //                                 fontWeight: FontWeight.w500,
// // //                               ),
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       const SizedBox(
// // //                         height: 30,
// // //                       ),

// // //                       const Text(
// // //                         "Already have an account?",
// // //                         style:
// // //                             TextStyle(color: Color(0xFF092D3F), fontSize: 20),
// // //                       ),
// // //                       const SizedBox(
// // //                         height: 8,
// // //                       ),

// // // //Login Button

// // //                       GestureDetector(
// // //                         //method for create account
// // //                         onTap: () {
// // //                           widget.toggle();
// // //                         },
// // //                         child: Container(
// // //                           width: 275,
// // //                           height: 50,
// // //                           decoration: ShapeDecoration(
// // //                             color: Colors.white,
// // //                             shape: RoundedRectangleBorder(
// // //                               borderRadius: BorderRadius.circular(35),
// // //                               side: const BorderSide(
// // //                                 width: 2,
// // //                                 color: Color(0xFF29F6D2),
// // //                               ),
// // //                             ),
// // //                           ),
// // //                           child: const Center(
// // //                             child: Text(
// // //                               'Login',
// // //                               style: TextStyle(
// // //                                 color: Color(0xFF29F6D2),
// // //                                 fontSize: 25,
// // //                                 fontFamily: 'Work Sans',
// // //                                 fontWeight: FontWeight.w500,
// // //                               ),
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'dart:typed_data';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_application_1/Services/auth_firebase.dart';
// // import 'package:flutter_application_1/Widgets/navigation_bar.dart';
// // import 'package:flutter_application_1/utils/util_functions.dart';
// // import 'package:image_picker/image_picker.dart';

// // class CreateAccount extends StatefulWidget {
// //   final Function toggle;
// //   const CreateAccount({Key? key, required this.toggle}) : super(key: key);

// //   @override
// //   State<CreateAccount> createState() => _CreateAccountState();
// // }

// // class _CreateAccountState extends State<CreateAccount> {
// //   final TextEditingController _emailController = TextEditingController();
// //   final TextEditingController _passwordController = TextEditingController();
// //   final TextEditingController _majorController = TextEditingController();
// //   final TextEditingController _userNameController = TextEditingController();
// //   final TextEditingController _confirmPassword = TextEditingController();
// //   Uint8List? _profileImage;
// //   bool isLoading = false;
// //   final AuthServices _auth = AuthServices();
// //   final _formKey = GlobalKey<FormState>();
// //   String? _generalErrorMessage;

// //   // void registerUser() async {
// //   //   if (_formKey.currentState!.validate() && _profileImage != null) {
// //   //     setState(() {
// //   //       isLoading = true;
// //   //     });

// //   //     String email = _emailController.text.trim();
// //   //     String password = _passwordController.text.trim();
// //   //     String major = _majorController.text.trim();
// //   //     String userName = _userNameController.text.trim();
// //   //     String confirmPassword = _confirmPassword.text.trim();

// //   //     String result = await _auth.registerWithEmailAndPassword(
// //   //       email: email,
// //   //       password: password,
// //   //       userName: userName,
// //   //       major: major,
// //   //       confirmPassword: confirmPassword,
// //   //       profilePic: _profileImage!,
// //   //     );

// //   //     if (result == "email-already-in-use") {
// //   //       setState(() {
// //   //         _generalErrorMessage = "Email already in use";
// //   //       });
// //   //     } else if (result == "user-name-already-taken") {
// //   //       setState(() {
// //   //         _generalErrorMessage = "User name already taken";
// //   //       });
// //   //     } else if (result == "success") {
// //   //       Navigator.pushReplacement(
// //   //         context,
// //   //         MaterialPageRoute(
// //   //           builder: (context) => const NavigationBarBottom(),
// //   //         ),
// //   //       );
// //   //     } else {
// //   //       setState(() {
// //   //         _generalErrorMessage = result;
// //   //       });
// //   //     }
// //   //     setState(() {
// //   //       isLoading = false;
// //   //     });
// //   //   } else if (_profileImage == null) {
// //   //     setState(() {
// //   //       _generalErrorMessage = "Fill the all feilds";
// //   //     });
// //   //   }
// //   // }

// //   // void registerUser() async {
// //   //   if (_formKey.currentState!.validate()) {
// //   //     if (_profileImage == null) {
// //   //       setState(() {
// //   //         _generalErrorMessage = "Please upload a profile picture";
// //   //       });
// //   //       return;
// //   //     }

// //   //     setState(() {
// //   //       isLoading = true;
// //   //     });

// //   //     String email = _emailController.text.trim();
// //   //     String password = _passwordController.text.trim();
// //   //     String major = _majorController.text.trim();
// //   //     String userName = _userNameController.text.trim();
// //   //     String confirmPassword = _confirmPassword.text.trim();

// //   //     String result = await _auth.registerWithEmailAndPassword(
// //   //       email: email,
// //   //       password: password,
// //   //       userName: userName,
// //   //       major: major,
// //   //       confirmPassword: confirmPassword,
// //   //       profilePic: _profileImage!,
// //   //     );

// //   //     if (result == "email-already-in-use") {
// //   //       setState(() {
// //   //         _generalErrorMessage = "Email already in use";
// //   //       });
// //   //     } else if (result == "user-name-already-taken") {
// //   //       setState(() {
// //   //         _generalErrorMessage = "User name already taken";
// //   //       });
// //   //     } else if (result == "success") {
// //   //       Navigator.pushReplacement(
// //   //         context,
// //   //         MaterialPageRoute(
// //   //           builder: (context) => const NavigationBarBottom(),
// //   //         ),
// //   //       );
// //   //     } else {
// //   //       setState(() {
// //   //         _generalErrorMessage = result;
// //   //       });
// //   //     }
// //   //     setState(() {
// //   //       isLoading = false;
// //   //     });
// //   //   }
// //   // }

// //   void registerUser() async {
// //     if (_formKey.currentState!.validate()) {
// //       if (_profileImage == null) {
// //         setState(() {
// //           _generalErrorMessage = "Please upload a profile picture";
// //         });
// //         return;
// //       }

// //       setState(() {
// //         isLoading = true;
// //         _generalErrorMessage = null; // Clear the general error message
// //       });

// //       String email = _emailController.text.trim();
// //       String password = _passwordController.text.trim();
// //       String major = _majorController.text.trim();
// //       String userName = _userNameController.text.trim();
// //       String confirmPassword = _confirmPassword.text.trim();

// //       String result = await _auth.registerWithEmailAndPassword(
// //         email: email,
// //         password: password,
// //         userName: userName,
// //         major: major,
// //         confirmPassword: confirmPassword,
// //         profilePic: _profileImage!,
// //       );

// //       if (result == "email-already-in-use") {
// //         setState(() {
// //           _generalErrorMessage = "Email already in use";
// //         });
// //       } else if (result == "user-name-already-taken") {
// //         setState(() {
// //           _generalErrorMessage = "User name already taken";
// //         });
// //       } else if (result == "success") {
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(
// //             builder: (context) => const NavigationBarBottom(),
// //           ),
// //         );
// //       } else {
// //         setState(() {
// //           _generalErrorMessage = result;
// //         });
// //       }
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }

// //   void selectImage() async {
// //     Uint8List profileImage = await pickImage(ImageSource.gallery);
// //     setState(() {
// //       _profileImage = profileImage;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //       child: Scaffold(
// //         backgroundColor: Colors.white,
// //         body: Padding(
// //           padding: const EdgeInsets.all(40.0),
// //           child: SingleChildScrollView(
// //             child: Form(
// //               key: _formKey,
// //               child: Column(
// //                 children: [
// //                   const SizedBox(height: 30),
// //                   Image.asset(
// //                     "assets/LearnProLogo.jpg",
// //                     height: 200,
// //                     width: 200,
// //                   ),
// //                   const SizedBox(height: 30),
// //                   const Center(
// //                     child: Text(
// //                       "Create an Account",
// //                       style: TextStyle(
// //                         fontSize: 40,
// //                         fontWeight: FontWeight.w500,
// //                         color: Color(0xFF051A85),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 45),
// //                   Stack(
// //                     children: [
// //                       _profileImage != null
// //                           ? CircleAvatar(
// //                               radius: 50,
// //                               backgroundColor: Colors.grey[300],
// //                               backgroundImage: MemoryImage(_profileImage!),
// //                             )
// //                           : CircleAvatar(
// //                               radius: 50,
// //                               backgroundColor: Colors.grey[300],
// //                               backgroundImage:
// //                                   const AssetImage('assets/userIconImage.png'),
// //                             ),
// //                       Positioned(
// //                         bottom: 0,
// //                         right: 0,
// //                         child: Container(
// //                           height: 40,
// //                           width: 40,
// //                           decoration: BoxDecoration(
// //                             color: Colors.white70,
// //                             borderRadius: BorderRadius.circular(30),
// //                           ),
// //                           child: IconButton(
// //                             onPressed: selectImage,
// //                             icon: Icon(
// //                               Icons.add_a_photo,
// //                               color: Colors.grey[600],
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 10),
// //                   if (_generalErrorMessage != null)
// //                     Center(
// //                       child: Text(
// //                         _generalErrorMessage!,
// //                         style: TextStyle(
// //                           color: Theme.of(context).errorColor,
// //                           fontSize: 12,
// //                         ),
// //                       ),
// //                     ),
// //                   const SizedBox(height: 10),
// //                   TextFormField(
// //                     controller: _emailController,
// //                     decoration: InputDecoration(
// //                       labelText: "Email",
// //                       labelStyle: const TextStyle(
// //                         color: Color(0xFF16697A),
// //                         fontSize: 20,
// //                         fontWeight: FontWeight.w400,
// //                       ),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(5),
// //                       ),
// //                       focusedBorder: const OutlineInputBorder(
// //                         borderSide: BorderSide(
// //                           color: Color(0xFF16697A),
// //                           width: 2,
// //                         ),
// //                       ),
// //                     ),
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return "Email cannot be empty";
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   const SizedBox(height: 30),
// //                   TextFormField(
// //                     controller: _userNameController,
// //                     decoration: InputDecoration(
// //                       labelText: "User Name",
// //                       labelStyle: const TextStyle(
// //                         color: Color(0xFF16697A),
// //                         fontSize: 20,
// //                         fontWeight: FontWeight.w400,
// //                       ),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(5),
// //                       ),
// //                       focusedBorder: const OutlineInputBorder(
// //                         borderSide: BorderSide(
// //                           color: Color(0xFF16697A),
// //                           width: 2,
// //                         ),
// //                       ),
// //                     ),
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return "User Name cannot be empty";
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   const SizedBox(height: 30),
// //                   TextFormField(
// //                     controller: _majorController,
// //                     decoration: InputDecoration(
// //                       labelText: "Major",
// //                       labelStyle: const TextStyle(
// //                         color: Color(0xFF16697A),
// //                         fontSize: 20,
// //                         fontWeight: FontWeight.w400,
// //                       ),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(5),
// //                       ),
// //                       focusedBorder: const OutlineInputBorder(
// //                         borderSide: BorderSide(
// //                           color: Color(0xFF16697A),
// //                           width: 2,
// //                         ),
// //                       ),
// //                     ),
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return "Major cannot be empty";
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   const SizedBox(height: 30),
// //                   TextFormField(
// //                     controller: _passwordController,
// //                     obscureText: true,
// //                     decoration: InputDecoration(
// //                       labelText: "Password",
// //                       labelStyle: const TextStyle(
// //                         color: Color(0xFF16697A),
// //                         fontSize: 20,
// //                         fontWeight: FontWeight.w400,
// //                       ),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(5),
// //                       ),
// //                       focusedBorder: const OutlineInputBorder(
// //                         borderSide: BorderSide(
// //                           color: Color(0xFF16697A),
// //                           width: 2,
// //                         ),
// //                       ),
// //                     ),
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return "Password cannot be empty";
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   const SizedBox(height: 30),
// //                   TextFormField(
// //                     controller: _confirmPassword,
// //                     obscureText: true,
// //                     decoration: InputDecoration(
// //                       labelText: "Confirm Password",
// //                       labelStyle: const TextStyle(
// //                         color: Color(0xFF16697A),
// //                         fontSize: 20,
// //                         fontWeight: FontWeight.w400,
// //                       ),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(5),
// //                       ),
// //                       focusedBorder: const OutlineInputBorder(
// //                         borderSide: BorderSide(
// //                           color: Color(0xFF16697A),
// //                           width: 2,
// //                         ),
// //                       ),
// //                     ),
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return "Confirm Password cannot be empty";
// //                       } else if (value != _passwordController.text) {
// //                         return "Passwords do not match";
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   const SizedBox(height: 20),
// //                   if (_generalErrorMessage != null)
// //                     Text(
// //                       _generalErrorMessage!,
// //                       style: TextStyle(color: Theme.of(context).errorColor),
// //                     ),
// //                   const SizedBox(height: 20),
// //                   //Register Button

// //                   GestureDetector(
// //                     onTap: () async {
// // //calling method for register the user
// //                       isLoading
// //                           ? const CircularProgressIndicator(
// //                               color: Colors.blue,
// //                             )
// //                           : registerUser();
// //                     },
// //                     child: Container(
// //                       width: 275,
// //                       height: 50,
// //                       decoration: ShapeDecoration(
// //                         color: const Color(0xFF29F6D2),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(35),
// //                         ),
// //                         shadows: const [
// //                           BoxShadow(
// //                             color: Color(0x3F000000),
// //                             blurRadius: 4,
// //                             offset: Offset(0, 4),
// //                             spreadRadius: 0,
// //                           )
// //                         ],
// //                       ),
// //                       child: const Center(
// //                         child: Text(
// //                           'Register',
// //                           style: TextStyle(
// //                             color: Colors.black,
// //                             fontSize: 25,
// //                             fontFamily: 'Work Sans',
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 30),
// //                   const Text(
// //                     "Already have an account?",
// //                     style: TextStyle(color: Color(0xFF092D3F), fontSize: 20),
// //                   ),
// //                   const SizedBox(
// //                     height: 8,
// //                   ),

// //                   //Login Button

// //                   GestureDetector(
// //                     //method for create account
// //                     onTap: () {
// //                       widget.toggle();
// //                     },
// //                     child: Container(
// //                       width: 275,
// //                       height: 50,
// //                       decoration: ShapeDecoration(
// //                         color: Colors.white,
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(35),
// //                           side: const BorderSide(
// //                             width: 2,
// //                             color: Color(0xFF29F6D2),
// //                           ),
// //                         ),
// //                       ),
// //                       child: const Center(
// //                         child: Text(
// //                           'Login',
// //                           style: TextStyle(
// //                             color: Color(0xFF29F6D2),
// //                             fontSize: 25,
// //                             fontFamily: 'Work Sans',
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Services/auth_firebase.dart';
// import 'package:flutter_application_1/Widgets/navigation_bar.dart';
// import 'package:flutter_application_1/utils/util_functions.dart';
// import 'package:image_picker/image_picker.dart';

// class CreateAccount extends StatefulWidget {
//   final Function toggle;
//   const CreateAccount({Key? key, required this.toggle}) : super(key: key);

//   @override
//   State<CreateAccount> createState() => _CreateAccountState();
// }

// class _CreateAccountState extends State<CreateAccount> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _majorController = TextEditingController();
//   final TextEditingController _userNameController = TextEditingController();
//   final TextEditingController _confirmPassword = TextEditingController();
//   Uint8List? _profileImage;
//   bool isLoading = false;
//   final AuthServices _auth = AuthServices();
//   final _formKey = GlobalKey<FormState>();

//   String? _profileImageError;
//   String? _emailError;
//   String? _userNameError;
//   String? _majorError;
//   String? _passwordError;
//   String? _confirmPasswordError;
//   String? _generalErrorMessage;

//   void registerUser() async {
//     setState(() {
//       _profileImageError =
//           _profileImage == null ? "Please upload a profile picture" : null;
//       _emailError =
//           _emailController.text.isEmpty ? "Email cannot be empty" : null;
//       _userNameError =
//           _userNameController.text.isEmpty ? "User Name cannot be empty" : null;
//       _majorError =
//           _majorController.text.isEmpty ? "Major cannot be empty" : null;
//       _passwordError =
//           _passwordController.text.isEmpty ? "Password cannot be empty" : null;
//       _confirmPasswordError = _confirmPassword.text.isEmpty
//           ? "Confirm Password cannot be empty"
//           : (_confirmPassword.text != _passwordController.text
//               ? "Passwords do not match"
//               : null);

//       _generalErrorMessage = _profileImageError != null ||
//               _emailError != null ||
//               _userNameError != null ||
//               _majorError != null ||
//               _passwordError != null ||
//               _confirmPasswordError != null
//           ? "Please fill all fields correctly"
//           : null;
//     });

//     if (_generalErrorMessage == null) {
//       setState(() {
//         isLoading = true;
//       });

//       String email = _emailController.text.trim();
//       String password = _passwordController.text.trim();
//       String major = _majorController.text.trim();
//       String userName = _userNameController.text.trim();
//       String confirmPassword = _confirmPassword.text.trim();

//       String result = await _auth.registerWithEmailAndPassword(
//         email: email,
//         password: password,
//         userName: userName,
//         major: major,
//         confirmPassword: confirmPassword,
//         profilePic: _profileImage!,
//       );

//       if (result == "email-already-in-use") {
//         setState(() {
//           _generalErrorMessage = "Email already in use";
//         });
//       } else if (result == "user-name-already-taken") {
//         setState(() {
//           _generalErrorMessage = "User name already taken";
//         });
//       } else if (result == "success") {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const NavigationBarBottom(),
//           ),
//         );
//       } else {
//         setState(() {
//           _generalErrorMessage = result;
//         });
//       }
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void selectImage() async {
//     Uint8List profileImage = await pickImage(ImageSource.gallery);
//     setState(() {
//       _profileImage = profileImage;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Padding(
//           padding: const EdgeInsets.all(40.0),
//           child: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   const SizedBox(height: 30),
//                   Image.asset(
//                     "assets/LearnProLogo.jpg",
//                     height: 200,
//                     width: 200,
//                   ),
//                   const SizedBox(height: 30),
//                   const Center(
//                     child: Text(
//                       "Create an Account",
//                       style: TextStyle(
//                         fontSize: 40,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF051A85),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 45),
//                   Stack(
//                     children: [
//                       _profileImage != null
//                           ? CircleAvatar(
//                               radius: 50,
//                               backgroundColor: Colors.grey[300],
//                               backgroundImage: MemoryImage(_profileImage!),
//                             )
//                           : CircleAvatar(
//                               radius: 50,
//                               backgroundColor: Colors.grey[300],
//                               backgroundImage:
//                                   const AssetImage('assets/userIconImage.png'),
//                             ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: Container(
//                           height: 40,
//                           width: 40,
//                           decoration: BoxDecoration(
//                             color: Colors.white70,
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           child: IconButton(
//                             onPressed: selectImage,
//                             icon: Icon(
//                               Icons.add_a_photo,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   if (_profileImageError != null)
//                     Center(
//                       child: Text(
//                         _profileImageError!,
//                         style: TextStyle(
//                           color: Theme.of(context).errorColor,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                       labelText: "Email",
//                       labelStyle: const TextStyle(
//                         color: Color(0xFF16697A),
//                         fontSize: 20,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       focusedBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0xFF16697A),
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Email cannot be empty";
//                       }
//                       return null;
//                     },
//                   ),
//                   if (_emailError != null)
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         _emailError!,
//                         style: TextStyle(
//                           color: Theme.of(context).errorColor,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   const SizedBox(height: 30),
//                   TextFormField(
//                     controller: _userNameController,
//                     decoration: InputDecoration(
//                       labelText: "User Name",
//                       labelStyle: const TextStyle(
//                         color: Color(0xFF16697A),
//                         fontSize: 20,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       focusedBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0xFF16697A),
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "User Name cannot be empty";
//                       }
//                       return null;
//                     },
//                   ),
//                   if (_userNameError != null)
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         _userNameError!,
//                         style: TextStyle(
//                           color: Theme.of(context).errorColor,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   const SizedBox(height: 30),
//                   TextFormField(
//                     controller: _majorController,
//                     decoration: InputDecoration(
//                       labelText: "Major",
//                       labelStyle: const TextStyle(
//                         color: Color(0xFF16697A),
//                         fontSize: 20,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       focusedBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0xFF16697A),
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Major cannot be empty";
//                       }
//                       return null;
//                     },
//                   ),
//                   if (_majorError != null)
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         _majorError!,
//                         style: TextStyle(
//                           color: Theme.of(context).errorColor,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   const SizedBox(height: 30),
//                   TextFormField(
//                     controller: _passwordController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       labelText: "Password",
//                       labelStyle: const TextStyle(
//                         color: Color(0xFF16697A),
//                         fontSize: 20,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       focusedBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0xFF16697A),
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Password cannot be empty";
//                       }
//                       return null;
//                     },
//                   ),
//                   if (_passwordError != null)
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         _passwordError!,
//                         style: TextStyle(
//                           color: Theme.of(context).errorColor,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   const SizedBox(height: 30),
//                   TextFormField(
//                     controller: _confirmPassword,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       labelText: "Confirm Password",
//                       labelStyle: const TextStyle(
//                         color: Color(0xFF16697A),
//                         fontSize: 20,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       focusedBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0xFF16697A),
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Confirm Password cannot be empty";
//                       } else if (value != _passwordController.text) {
//                         return "Passwords do not match";
//                       }
//                       return null;
//                     },
//                   ),
//                   if (_confirmPasswordError != null)
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         _confirmPasswordError!,
//                         style: TextStyle(
//                           color: Theme.of(context).errorColor,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   const SizedBox(height: 20),
//                   if (_generalErrorMessage != null)
//                     Text(
//                       _generalErrorMessage!,
//                       style: TextStyle(color: Theme.of(context).errorColor),
//                     ),
//                   const SizedBox(height: 20),
//                   GestureDetector(
//                     onTap: () async {
//                       isLoading
//                           ? const CircularProgressIndicator(
//                               color: Colors.blue,
//                             )
//                           : registerUser();
//                     },
//                     child: Container(
//                       height: 60,
//                       width: 350,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF16697A),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: const Text(
//                         "Register",
//                         style: TextStyle(
//                           fontSize: 22,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // Go to Login Page
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("Already have an account? ",
//                           style: TextStyle(
//                             fontSize: 16,
//                           )),
//                       GestureDetector(
//                         onTap: () {
//                           widget.toggle();
//                         },
//                         child: const Text(
//                           "Sign in",
//                           style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.blue,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/auth_firebase.dart';
import 'package:flutter_application_1/Widgets/navigation_bar.dart';
import 'package:flutter_application_1/utils/util_functions.dart';
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
  final _formKey = GlobalKey<FormState>();

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
            builder: (context) => const NavigationBarBottom(),
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                      "Create an Account",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF051A85),
                      ),
                    ),
                  ),
                  const SizedBox(height: 45),
                  Stack(
                    children: [
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
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
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
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
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
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return "Email cannot be empty";
                    //   }
                    //   return null;
                    // },
                  ),
                  if (_emailError != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _emailError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
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
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return "User Name cannot be empty";
                    //   }
                    //   return null;
                    // },
                  ),
                  if (_userNameError != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _userNameError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
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
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return "Major cannot be empty";
                    //   }
                    //   return null;
                    // },
                  ),
                  if (_majorError != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _majorError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
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
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return "Password cannot be empty";
                    //   }
                    //   return null;
                    // },
                  ),
                  if (_passwordError != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _passwordError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
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
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return "Confirm Password cannot be empty";
                    //   } else if (value != _passwordController.text) {
                    //     return "Passwords do not match";
                    //   }
                    //   return null;
                    // },
                  ),
                  if (_confirmPasswordError != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _confirmPasswordError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (_generalErrorMessage != null)
                    Text(
                      _generalErrorMessage!,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  const SizedBox(height: 20),
//                   GestureDetector(
//                     onTap: () async {
//                       if (!isLoading) registerUser();
//                     },
//                     child: Container(
//                       height: 60,
//                       width: 350,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF16697A),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: isLoading
//                           ? const CircularProgressIndicator(
//                               color: Colors.white,
//                             )
//                           : const Text(
//                               "Register",
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // Go to Login Page
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("Already have an account? ",
//                           style: TextStyle(
//                             fontSize: 16,
//                           )),
//                       GestureDetector(
//                         onTap: () {
//                           widget.toggle();
//                         },
//                         child: const Text(
//                           "Sign in",
//                           style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.blue,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
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
                    style: TextStyle(color: Color(0xFF092D3F), fontSize: 20),
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
          ),
        ),
      ),
    );
  }
}
