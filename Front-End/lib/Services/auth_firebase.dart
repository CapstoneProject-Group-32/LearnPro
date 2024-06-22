import 'dart:async';

import 'dart:typed_data';

import 'package:LearnPro/Screens/Authentication/continuing_registration.dart';
import 'package:LearnPro/Screens/Authentication/forgot_password_screen.dart';
import 'package:LearnPro/Widgets/navigation_bar.dart';
import 'package:LearnPro/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:LearnPro/Models/usermodel.dart';
import 'package:LearnPro/Services/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  //firebase instance

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods _storageMethods = StorageMethods();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  //create a user from firebase user with UID

  UserModel? _userWithFirebaseUserUid(User? user) {
    return user != null
        ? UserModel(
            uid: user.uid,
            email: '',
            userName: '',
            major: '',
            profilePic: '',
            friends: [],
          )
        : null;
  }

  //create the stream for checking the auth changes in the user

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userWithFirebaseUserUid);
  }

  //register using email and password

  Future<String> registerWithEmailAndPassword({
    required Uint8List profilePic,
    required String email,
    required String userName,
    required String major,
    required String password,
    required String confirmPassword,
  }) async {
    String res = "An error occurred";
    try {
      if (userName.isNotEmpty &&
          password.isNotEmpty &&
          email.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          major.isNotEmpty &&
          profilePic.isNotEmpty &&
          password == confirmPassword) {
        // Check if email is already registered
        QuerySnapshot emailCheck = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get();
        if (emailCheck.docs.isNotEmpty) {
          return "email-already-in-use";
        }

        // Check if username is already taken
        QuerySnapshot userNameCheck = await _firestore
            .collection('users')
            .where('userName', isEqualTo: userName)
            .get();
        if (userNameCheck.docs.isNotEmpty) {
          return "user-name-already-taken";
        }

        // Create a new user
        final UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        // Upload the profile pic to the storage
        String photoURL = await StorageMethods().uploadImage(
          folderName: "ProfileImages",
          isFile: false,
          file: profilePic,
        );

        UserModel user = UserModel(
          uid: _auth.currentUser!.uid,
          email: email,
          userName: userName,
          major: major,
          profilePic: photoURL,
          friends: [],
        );

        if (userCredential.user != null) {
          await _firestore.collection('users').doc(_auth.currentUser!.uid).set(
                user.toJSON(),
              );
          res = "success";
        }
      } else {
        res = "Passwords do not match or some fields are empty";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  //Email Verification

  Future<void> sendEmailVerificationLink() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }

  //login using email and password

  Future<String> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    String res = "Incorrect Email and Password";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please fill all fields correctly";
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == "invalid-email") {
        res = "Invalid email";
      } else if (error.code == "wrong-password") {
        res = "wrong-password";
      } else if (error.code == "user-not-found") {
        res = "user-not-found";
      }
    } catch (error) {
      res = error.toString();
    }

    return res;
  }

  //Forgot Password

  Future<void> sendPasswordResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  // get the current user details

  Future<UserModel?> getCurrentUser() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(currentUser.uid).get();

        if (snapshot.exists) {
          return UserModel.fromJSON(snapshot.data() as Map<String, dynamic>);
        } else {
          print('User document does not exist');
          return null;
        }
      } catch (error) {
        print('Error getting user document: $error');
        return null;
      }
    } else {
      print('No current user');
      return null;
    }
  }

  // get the current user's username
  Future<String?> getCurrentUserName() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(currentUser.uid).get();

        if (snapshot.exists) {
          return snapshot.get('userName') as String?;
        } else {
          print('User document does not exist');
          return null;
        }
      } catch (error) {
        print('Error getting user document: $error');
        return null;
      }
    } else {
      print('No current user');
      return null;
    }
  }

// get the current user's userprofilePic

  Future<String?> getProfilePicURL(String uid) async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(currentUser.uid).get();

        if (snapshot.exists) {
          return snapshot.get('profilePic') as String?;
        } else {
          print('User document does not exist');
          return null;
        }
      } catch (error) {
        print('Error getting user document: $error');
        return null;
      }
    } else {
      print('No current user');
      return null;
    }
  }

  //logout

  Future logOut() async {
    return await _auth.signOut();
  }

  //update user profile for continuing registration

  Future<String> updateProfile({
    required String userName,
    required String major,
    Uint8List? profilePic,
  }) async {
    String res = "An error occurred";
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Check if username is already taken
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .where('userName', isEqualTo: userName)
            .get();
        if (querySnapshot.docs.isNotEmpty &&
            querySnapshot.docs.first.id != currentUser.uid) {
          return "User name is already taken";
        }

        String? photoURL;
        if (profilePic != null) {
          photoURL = await StorageMethods().uploadImage(
            folderName: "ProfileImages",
            isFile: false,
            file: profilePic,
          );
        }

        Map<String, dynamic> updatedData = {
          'userName': userName,
          'major': major,
        };

        if (photoURL != null) {
          updatedData['profilePic'] = photoURL;
        }

        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .update(updatedData);
        res = "success";
      } else {
        res = "User not logged in";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  // Clear previous Google sign-in session
  Future<void> clearGoogleSignInSession() async {
    await _googleSignIn.signOut();
  }

  // Sign in with Google
  Future<bool> signInWithGoogle(BuildContext context) async {
    try {
      await clearGoogleSignInSession();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(user.uid).get();
        if (snapshot.exists) {
          return true;
        } else {
          String? profilePicUrl;
          if (user.photoURL != null && user.photoURL!.isNotEmpty) {
            // Fetch and upload the profile picture to Firebase Storage
            final http.Response response =
                await http.get(Uri.parse(user.photoURL!));
            if (response.statusCode == 200) {
              Uint8List data = response.bodyBytes;
              profilePicUrl = await _storageMethods.uploadImage(
                folderName: 'ProfileImages',
                isFile: false,
                file: data,
              );
            }
          }

          // Save the email, profile picture URL, and additional fields in Firestore (half registration)
          await _firestore.collection('users').doc(user.uid).set({
            'email': user.email,
            'profilePic': profilePicUrl ?? '',
            'uid': user.uid,
            'userName': '',
            'major': '',
            'friends': [],
          });

          return false;
        }
      } else {
        print("User is null after sign-in");
        return false;
      }
    } catch (e) {
      print("Error during Google sign-in: ${e.toString()}");
      return false;
    }
  }
}
