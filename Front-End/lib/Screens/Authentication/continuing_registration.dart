import 'dart:typed_data';
import 'package:LearnPro/Services/storage_services.dart';
import 'package:LearnPro/Widgets/navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:LearnPro/Models/usermodel.dart';
import 'package:LearnPro/Services/auth_firebase.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ContinuingRegistration extends StatefulWidget {
  final GoogleSignInAccount? googleUser;

  const ContinuingRegistration({super.key, this.googleUser});

  @override
  State<ContinuingRegistration> createState() => _ContinuingRegistrationState();
}

class _ContinuingRegistrationState extends State<ContinuingRegistration> {
  final AuthServices _auth = AuthServices();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth1 = FirebaseAuth.instance;
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  String? _profileImageUrl;
  String? _profileImageError;
  String? _userNameError;
  String? _majorError;
  String? _generalErrorMessage;
  Uint8List? _profileImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _halfRegisterGoogleUser();
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
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
    return null;
  }

  Future<void> _halfRegisterGoogleUser() async {
    if (widget.googleUser == null) return;

    User? currentUser = _auth1.currentUser;
    if (currentUser == null) return;

    String? profilePicUrl;
    if (widget.googleUser!.photoUrl != null &&
        widget.googleUser!.photoUrl!.isNotEmpty) {
      final http.Response response =
          await http.get(Uri.parse(widget.googleUser!.photoUrl!));
      if (response.statusCode == 200) {
        Uint8List data = response.bodyBytes;
        profilePicUrl = await StorageMethods().uploadImage(
          folderName: 'ProfileImages',
          isFile: false,
          file: data,
        );
      }
    }

    await _firestore.collection('users').doc(currentUser.uid).set({
      'email': widget.googleUser!.email,
      'profilePic': profilePicUrl ?? '',
      'uid': currentUser.uid,
      'userName': '',
      'major': '',
      'friends': [],
    });
  }

  Future<void> _registerWithGoogleAccount() async {
    setState(() {
      isLoading = true;
      _profileImageError = null;
      _userNameError = null;
      _majorError = null;
      _generalErrorMessage = null;
    });

    if (_userNameController.text.isEmpty) {
      setState(() {
        _userNameError = "User name cannot be null";
      });
    }

    if (_majorController.text.isEmpty) {
      setState(() {
        _majorError = "Major cannot be null";
      });
    }

    if (_profileImage == null && _profileImageUrl == null) {
      setState(() {
        _profileImageError = "Profile image cannot be null";
      });
    }

    if (_userNameError != null ||
        _majorError != null ||
        _profileImageError != null) {
      setState(() {
        _generalErrorMessage = "Fill all the fields";
        isLoading = false;
      });
      return;
    }

    String res = await _auth.registerWithGoogleAccount(
      userName: _userNameController.text,
      major: _majorController.text,
      profilePic: _profileImage,
    );

    setState(() {
      isLoading = false;
    });

    if (res == "success") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NavigationBarBottom(),
        ),
      );
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Complete Registration",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
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
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: selectImage,
                            child: Column(
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
                                                backgroundColor:
                                                    Colors.grey[300],
                                                backgroundImage: NetworkImage(
                                                    _profileImageUrl!),
                                              )
                                            : CircleAvatar(
                                                radius: 50,
                                                backgroundColor:
                                                    Colors.grey[300],
                                                backgroundImage: const AssetImage(
                                                    'assets/defaultuser.png'),
                                              )),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade400,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 35,
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
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          const SizedBox(height: 35),
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
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          if (_generalErrorMessage != null)
                            Text(
                              _generalErrorMessage!,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                          const SizedBox(height: 25),
                          GestureDetector(
                            onTap: () async {
                              //calling method for update the user details
                              if (!isLoading) {
                                await _registerWithGoogleAccount();
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
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ]),
      ),
    );
  }
}
