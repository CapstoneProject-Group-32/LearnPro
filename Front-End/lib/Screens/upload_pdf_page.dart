import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

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
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields and select a file')));
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
      appBar: AppBar(title: const Text('Upload PDF')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  labelText: 'Subject'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
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
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Choose PDF'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _uploadFile,
                    child: const Text('Submit'),
                  ),
          ],
        ),
      ),
    );
  }
}
