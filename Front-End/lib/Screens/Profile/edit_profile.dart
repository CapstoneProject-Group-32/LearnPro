// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Services/auth_firebase.dart';
// import 'package:flutter_application_1/utils/util_functions.dart';
// import 'package:image_picker/image_picker.dart';

// class EditProfile extends StatefulWidget {
//   const EditProfile({super.key});

//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }

// class _EditProfileState extends State<EditProfile> {
//   final TextEditingController _majorController = TextEditingController();
//   final TextEditingController _userNameController = TextEditingController();
//   Uint8List? _profileImage;

//   bool isLoading = false;

//   final AuthServices _auth = AuthServices();

//   String? _profileImageError;
//   String? _userNameError;
//   String? _majorError;
//   String? _generalErrorMessage;

//   void updateUserDeatils() {}

//   void selectImage() async {
//     Uint8List profileImage = await pickImage(ImageSource.gallery);
//     setState(() {
//       _profileImage = profileImage;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: AppBar(
//         title: const Text(
//           "Update Profile",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: Colors.black,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new_rounded,
//             size: 20,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 Form(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Stack(
//                             children: [
//                               _profileImage != null
//                                   ? CircleAvatar(
//                                       radius: 50,
//                                       backgroundColor: Colors.grey[300],
//                                       backgroundImage:
//                                           MemoryImage(_profileImage!),
//                                     )
//                                   : CircleAvatar(
//                                       radius: 50,
//                                       backgroundColor: Colors.grey[300],
//                                       backgroundImage: const AssetImage(
//                                           'assets/userIconImage.png'),
//                                     ),
//                               Positioned(
//                                 bottom: 0,
//                                 right: 0,
//                                 child: Container(
//                                   height: 40,
//                                   width: 40,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white70,
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                   child: IconButton(
//                                     onPressed: selectImage,
//                                     icon: Icon(
//                                       Icons.edit,
//                                       color: Colors.grey[600],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       if (_profileImageError != null)
//                         Center(
//                           child: Text(
//                             _profileImageError!,
//                             style: TextStyle(
//                               color: Theme.of(context).errorColor,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: _userNameController,
//                         decoration: InputDecoration(
//                           labelText: "User Name*",
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                         ),
//                       ),
//                       if (_userNameError != null)
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             _userNameError!,
//                             style: TextStyle(
//                               color: Theme.of(context).errorColor,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       const SizedBox(height: 30),
//                       TextFormField(
//                         controller: _majorController,
//                         decoration: InputDecoration(
//                           labelText: "Major*",
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                         ),
//                       ),
//                       if (_majorError != null)
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             _majorError!,
//                             style: TextStyle(
//                               color: Theme.of(context).errorColor,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),

//                       const SizedBox(height: 20),
//                       if (_generalErrorMessage != null)
//                         Text(
//                           _generalErrorMessage!,
//                           style: TextStyle(color: Theme.of(context).errorColor),
//                         ),
//                       const SizedBox(height: 20),

//                       //Update Button

//                       GestureDetector(
//                         onTap: () async {
//                           //calling method for update the user details
//                           isLoading
//                               ? const CircularProgressIndicator(
//                                   color: Colors.blue,
//                                 )
//                               : updateUserDeatils();
//                         },
//                         child: Container(
//                           width: 275,
//                           height: 50,
//                           decoration: ShapeDecoration(
//                             color: Theme.of(context).colorScheme.secondary,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(35),
//                             ),
//                             shadows: const [
//                               BoxShadow(
//                                 color: Color(0x3F000000),
//                                 blurRadius: 4,
//                                 offset: Offset(0, 4),
//                                 spreadRadius: 0,
//                               )
//                             ],
//                           ),
//                           child: const Center(
//                             child: Text(
//                               'Update',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 20,
//                                 fontFamily: 'Work Sans',
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(
//                         height: 20,
//                       ),
//                     ],
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

// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Models/usermodel.dart';
// import 'package:flutter_application_1/Services/auth_firebase.dart';
// import 'package:image_picker/image_picker.dart';

// class EditProfile extends StatefulWidget {
//   const EditProfile({super.key});

//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }

// class _EditProfileState extends State<EditProfile> {
//   final TextEditingController _majorController = TextEditingController();
//   final TextEditingController _userNameController = TextEditingController();
//   Uint8List? _profileImage;

//   bool isLoading = false;

//   final AuthServices _auth = AuthServices();

//   String? _profileImageError;
//   String? _userNameError;
//   String? _majorError;
//   String? _generalErrorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     UserModel? currentUser = await _auth.getCurrentUser();
//     if (currentUser != null) {
//       setState(() {
//         _userNameController.text = currentUser.userName;
//         _majorController.text = currentUser.major;
//         _profileImage = currentUser.profilePic != null
//             ? Uint8List.fromList(currentUser.profilePic.codeUnits)
//             : null;
//       });
//     }
//   }

//   Future<void> selectImage() async {
//     Uint8List? profileImage = await _pickImage(ImageSource.gallery);

//     setState(() {
//       _profileImage = profileImage;
//     });
//   }

//   Future<Uint8List?> _pickImage(ImageSource source) async {
//     final ImagePicker _imagePicker = ImagePicker();
//     XFile? _file = await _imagePicker.pickImage(source: source);
//     if (_file != null) {
//       return await _file.readAsBytes();
//     }
//     return null;
//   }

//   Future<void> _updateProfile() async {
//     setState(() {
//       isLoading = true;
//     });

//     String res = await _auth.updateProfile(
//       userName: _userNameController.text,
//       major: _majorController.text,
//       profilePic: _profileImage,
//     );

//     setState(() {
//       isLoading = false;
//     });

//     if (res == "success") {
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(res)),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: AppBar(
//         title: const Text(
//           "Update Profile",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: Colors.black,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new_rounded,
//             size: 20,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 Form(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Stack(
//                             children: [
//                               _profileImage != null
//                                   ? CircleAvatar(
//                                       radius: 50,
//                                       backgroundColor: Colors.grey[300],
//                                       backgroundImage:
//                                           MemoryImage(_profileImage!),
//                                     )
//                                   : CircleAvatar(
//                                       radius: 50,
//                                       backgroundColor: Colors.grey[300],
//                                       backgroundImage: const AssetImage(
//                                           'assets/userIconImage.png'),
//                                     ),
//                               Positioned(
//                                 bottom: 0,
//                                 right: 0,
//                                 child: Container(
//                                   height: 40,
//                                   width: 40,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white70,
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                   child: IconButton(
//                                     onPressed: selectImage,
//                                     icon: Icon(
//                                       Icons.edit,
//                                       color: Colors.grey[600],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       if (_profileImageError != null)
//                         Center(
//                           child: Text(
//                             _profileImageError!,
//                             style: TextStyle(
//                               color: Theme.of(context).errorColor,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: _userNameController,
//                         decoration: InputDecoration(
//                           labelText: "User Name*",
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                         ),
//                       ),
//                       if (_userNameError != null)
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             _userNameError!,
//                             style: TextStyle(
//                               color: Theme.of(context).errorColor,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       const SizedBox(height: 30),
//                       TextFormField(
//                         controller: _majorController,
//                         decoration: InputDecoration(
//                           labelText: "Major*",
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                         ),
//                       ),
//                       if (_majorError != null)
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             _majorError!,
//                             style: TextStyle(
//                               color: Theme.of(context).errorColor,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       const SizedBox(height: 20),
//                       if (_generalErrorMessage != null)
//                         Text(
//                           _generalErrorMessage!,
//                           style: TextStyle(color: Theme.of(context).errorColor),
//                         ),
//                       const SizedBox(height: 20),
//                       GestureDetector(
//                         onTap: () async {
//                           //calling method for update the user details
//                           isLoading
//                               ? const CircularProgressIndicator(
//                                   color: Colors.blue,
//                                 )
//                               : _updateProfile();
//                         },
//                         child: Container(
//                           width: 275,
//                           height: 50,
//                           decoration: ShapeDecoration(
//                             color: Theme.of(context).colorScheme.secondary,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(35),
//                             ),
//                             shadows: const [
//                               BoxShadow(
//                                 color: Color(0x3F000000),
//                                 blurRadius: 4,
//                                 offset: Offset(0, 4),
//                                 spreadRadius: 0,
//                               )
//                             ],
//                           ),
//                           child: const Center(
//                             child: Text(
//                               'Update',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 20,
//                                 fontFamily: 'Work Sans',
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                     ],
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

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/usermodel.dart';
import 'package:flutter_application_1/Services/auth_firebase.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  Uint8List? _profileImage;
  String? _profileImageUrl;

  bool isLoading = false;

  final AuthServices _auth = AuthServices();

  String? _profileImageError;
  String? _userNameError;
  String? _majorError;
  String? _generalErrorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    UserModel? currentUser = await _auth.getCurrentUser();
    if (currentUser != null) {
      setState(() {
        _userNameController.text = currentUser.userName;
        _majorController.text = currentUser.major;
        _profileImageUrl = currentUser.profilePic; // Load the profile image URL
      });
    }
  }

  Future<void> selectImage() async {
    Uint8List? profileImage = await _pickImage(ImageSource.gallery);
    setState(() {
      _profileImage = profileImage;
      _profileImageUrl = null; // Clear the URL when a new image is selected
    });
  }

  Future<Uint8List?> _pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    return null;
  }

  Future<void> _updateProfile() async {
    setState(() {
      isLoading = true;
    });

    String res = await _auth.updateProfile(
      userName: _userNameController.text,
      major: _majorController.text,
      profilePic: _profileImage,
    );

    setState(() {
      isLoading = false;
    });

    if (res == "success") {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res)),
      );
      if (res.contains("User name is already taken")) {
        setState(() {
          _userNameError = "User name is already taken";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "Update Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(children: [
        SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
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
                                    : (_profileImageUrl != null
                                        ? CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.grey[300],
                                            backgroundImage:
                                                NetworkImage(_profileImageUrl!),
                                          )
                                        : CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.grey[300],
                                            backgroundImage: const AssetImage(
                                                'assets/userIconImage.png'),
                                          )),
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
                                        Icons.edit,
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
                        const SizedBox(height: 20),
                        if (_generalErrorMessage != null)
                          Text(
                            _generalErrorMessage!,
                            style:
                                TextStyle(color: Theme.of(context).errorColor),
                          ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () async {
                            //calling method for update the user details
                            if (isLoading) {
                              const CircularProgressIndicator(
                                color: Colors.blue,
                              );
                            } else {
                              await _updateProfile();
                            }
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
                                'Update',
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
        if (isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ]),
    );
  }
}
