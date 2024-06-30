import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:LearnPro/Models/usermodel.dart';
import 'package:LearnPro/Services/auth_firebase.dart';
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
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
    return null;
  }

  Future<void> _updateProfile() async {
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
      body: Stack(
        children: [
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
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () async {
                              //calling method for update the user details
                              if (!isLoading) {
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
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
