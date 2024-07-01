import 'package:LearnPro/tutoring_system/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../tutoring_system/custom_appbar.dart';

class UploadPdfPage extends StatefulWidget {
  const UploadPdfPage({super.key});

  @override
  _UploadPdfPageState createState() => _UploadPdfPageState();
}

class _UploadPdfPageState extends State<UploadPdfPage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  PlatformFile? _pickedFile;
  bool _isLoading = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_pickedFile == null ||
        _subjectController.text.isEmpty ||
        _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill all fields and select a file')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String fileName = _pickedFile!.name;
        String filePath = 'usernotes/${user.uid}/$fileName';

        File file = File(_pickedFile!.path!);

        Reference ref = FirebaseStorage.instance.ref().child(filePath);
        await ref.putFile(file);

        String downloadUrl = await ref.getDownloadURL();

        final documentReference = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('usernotes')
            .add({
          'pdfid': "",
          'subject': _subjectController.text,
          'title': _titleController.text,
          'url': downloadUrl,
          'fileName': fileName,
        });

        final noteid = documentReference.id;
        await documentReference.update({
          'pdfid': noteid,
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Upload successful')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Upload Notes'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  labelText: 'Subject'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  labelText: 'Title'),
            ),
            const SizedBox(height: 20),
            _pickedFile != null
                ? Column(
                    children: [
                      Text('Selected file: ${_pickedFile!.name}'),
                      Text(
                          'Size: ${(_pickedFile!.size / 1024).toStringAsFixed(2)} KB'),
                    ],
                  )
                : Container(),
            CustomButton(
              text: 'Choose PDF',
              onPressed: _pickFile,
              backgroundColor: Colors.white38,
            ),
            // ElevatedButton(
            //   onPressed: _pickFile,
            //   child: const Text('Choose PDF'),
            // ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 40,
                  width: 120,
                  child: CustomButton(
                    text: "Cancel",
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: Theme.of(context).colorScheme.background,
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    // foregroundColor: Colors.red,
                    borderColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        height: 40,
                        width: 120,
                        child: CustomButton(
                          text: "Submit",
                          onPressed: _uploadFile,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                      ),
              ],
            )

            //  ElevatedButton(
            //     onPressed: _uploadFile,
            //     child: const Text('Submit'),
            //   ),
          ],
        ),
      ),
    );
  }
}
