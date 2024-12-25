import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import '../tutoring_system/custom_appbar.dart';
import '../tutoring_system/custom_button.dart';
import 'invite_friends_screen.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  String? groupName, groupMajor, groupDescription;
  XFile? groupIcon;
  List<String> invitedFriendsUIDs = [];
  List<String> invitedFriendsUsernames = [];
  bool isLoading = false;

  Future<void> pickGroupIcon() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      groupIcon = pickedFile;
    });
  }

  void inviteFriends() async {
    // Navigate to invite friends screen and get the invited friends' UIDs and usernames
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InviteFriendsScreen()),
    );
    if (result != null) {
      setState(() {
        invitedFriendsUIDs = List<String>.from(result['uids']);
        invitedFriendsUsernames = List<String>.from(result['usernames']);
      });
    }
  }

  Future<void> createGroup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (groupIcon == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add a group icon')),
        );
        return;
      }

      setState(() {
        isLoading = true;
      });

      try {
        // Check if the group name already exists
        var groupDoc = await FirebaseFirestore.instance
            .collection('groups')
            .doc(groupName)
            .get();
        if (groupDoc.exists) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Group name already exists')));
          setState(() {
            isLoading = false;
          });
          return;
        }

        // Upload the group icon to Firebase Storage
        String? groupIconUrl;
        if (groupIcon != null) {
          var storageRef = FirebaseStorage.instance
              .ref()
              .child('groups/$groupName/groupicon/${groupIcon!.name}');
          await storageRef.putFile(File(groupIcon!.path));
          groupIconUrl = await storageRef.getDownloadURL();
        }

        // Create the group document in Firestore
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(groupName)
            .set({
          'groupname': groupName,
          'groupmajor': groupMajor,
          'groupdescription': groupDescription,
          'owner': FirebaseAuth.instance.currentUser!.uid,
          'groupicon': groupIconUrl,
          'invitedmembers': invitedFriendsUIDs,
          'members': [FirebaseAuth.instance.currentUser!.uid],
        });

        // Update invited friends' documents
        for (var uid in invitedFriendsUIDs) {
          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'groupinvitations': FieldValue.arrayUnion([groupName]),
          });
        }

        // Update the owner's document
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'joinedgroups': FieldValue.arrayUnion([groupName]),
        });

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Group created successfully')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill every field and add a group icon')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Create a Group'),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      labelText: 'Group Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a group name';
                    }
                    return null;
                  },
                  onSaved: (value) => groupName = value,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      labelText: 'Major'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the major';
                    }
                    return null;
                  },
                  onSaved: (value) => groupMajor = value,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) => groupDescription = value,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Choose Group Icon',
                  onPressed: pickGroupIcon,
                  backgroundColor: Colors.white38,
                ),
                // ElevatedButton(
                //   onPressed: pickGroupIcon,
                //   child: const Text('Choose Group Icon'),
                // ),
                groupIcon != null
                    ? Image.file(File(groupIcon!.path))
                    : Container(),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Invite Friends',
                  onPressed: inviteFriends,
                  backgroundColor: Colors.white70,
                ),
                // ElevatedButton(
                //   onPressed: inviteFriends,
                //   child: const Text('Invite Friends'),
                // ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: invitedFriendsUsernames.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          invitedFriendsUsernames[index]), // Display usernames
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ElevatedButton(
                    //   onPressed: () => Navigator.pop(context),
                    //   child: const Text('Cancel'),
                    // ),

                    SizedBox(
                      height: 40,
                      width: 120,
                      child: CustomButton(
                        text: "Cancel",
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        backgroundColor:
                            Theme.of(context).colorScheme.surface,
                        foregroundColor:
                            Theme.of(context).colorScheme.secondary,
                        // foregroundColor: Colors.red,
                        borderColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 20, // newly added
                          shadowColor:
                              Colors.grey[800]?.withOpacity(0.15), //newly added
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          // foregroundColor: foregroundColor,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: isLoading ? null : createGroup,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(
                                'Create',
                                style: TextStyle(
                                  color: textColor,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
