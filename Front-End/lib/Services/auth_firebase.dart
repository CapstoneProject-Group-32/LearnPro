import 'dart:async';

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_application_1/Models/usermodel.dart';
import 'package:flutter_application_1/Services/storage_services.dart';

class AuthServices {
  //firebase instance

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //create a user from firebase user with UID

  UserModel? _userWithFirebaseUserUid(User? user) {
    return user != null
        ? UserModel(
            uid: user.uid,
            email: '',
            userName: '',
            major: '',
            profilePic: '',
            friends: [])
        : null;
  }

  //create the stream for checking the auth changes in the user

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userWithFirebaseUserUid);
  }

  //LogIn Anonymous

  Future logInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userWithFirebaseUserUid(user);
    } catch (err) {
      print(err.toString());
      return null;
    }
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
    String res = "An error occured";
    try {
      if (userName.isNotEmpty &&
          password.isNotEmpty &&
          email.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          major.isNotEmpty &&
          profilePic.isNotEmpty &&
          password == confirmPassword) {
        //create a new user

        final UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        //the profile pic to the storage
        String photoURL = await StorageMethods().uploadImage(
            folderName: "ProfileImages", isFile: false, file: profilePic);

        UserModel user = UserModel(
            uid: _auth.currentUser!.uid,
            email: email,
            userName: userName,
            major: major,
            profilePic: photoURL,
            friends: []);

        if (userCredential.user != null) {
          await _firestore.collection('users').doc(_auth.currentUser!.uid).set(
                user.toJSON(),
              );
          res = "success";
        } else {
          res = "Passwords do not match or some fields are empty";
        }
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  //login using email and password

  Future<String> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    String res = "An error occured";

    try {
      //if the inputs are not empty
      if (email.isNotEmpty && password.isNotEmpty) {
        //login the user with email and password
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        res = "success";
      } else {
        res = "Please enter email and password";
      }
    }

    //catch the errors extra error handling
    on FirebaseAuthException catch (error) {
      if (error.code == "invalid-email") {
        res = "Invalid email";
      } else if (error.code == "weak-password") {
        res = "Weak password";
      } else if (error.code == "email-already-in-use") {
        res = "Email already in use";
      }
    } catch (error) {
      res = error.toString();
    }

    return res;
  }

  //logout

  Future logOut() async {
    return await _auth.signOut();
  }
}