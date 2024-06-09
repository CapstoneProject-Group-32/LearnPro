import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ContentUploadForm extends StatefulWidget {
  final String groupName;

  const ContentUploadForm({super.key, required this.groupName});

  @override
  _ContentUploadFormState createState() => _ContentUploadFormState();
}

class _ContentUploadFormState extends State<ContentUploadForm> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  String _fileType = 'pdf';
  List<File> _files = [];
  final picker = ImagePicker();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Content'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) => _description = value,
              ),
              Row(
                children: [
                  const Text('File Type:'),
                  Radio(
                    value: 'pdf',
                    groupValue: _fileType,
                    onChanged: (value) {
                      setState(() {
                        _fileType = value as String;
                        _files.clear();
                      });
                    },
                  ),
                  const Text('PDF'),
                  Radio(
                    value: 'images',
                    groupValue: _fileType,
                    onChanged: (value) {
                      setState(() {
                        _fileType = value as String;
                        _files.clear();
                      });
                    },
                  ),
                  const Text('Images'),
                ],
              ),
              ElevatedButton(
                onPressed: () => _pickFiles(),
                child: Text(_fileType == 'pdf' ? 'Choose PDF' : 'Pick Images'),
              ),
              Expanded(
                child:
                    _fileType == 'pdf' ? _buildPdfList() : _buildImagePreview(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _uploadContent(),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text('Upload'),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPdfList() {
    return ListView.builder(
      itemCount: _files.length,
      itemBuilder: (context, index) {
        File file = _files[index];
        return ListTile(
          leading: const Icon(Icons.picture_as_pdf),
          title: Text(file.path.split('/').last),
          subtitle: Text('${(file.lengthSync() / 1024).toStringAsFixed(2)} KB'),
        );
      },
    );
  }

  Widget _buildImagePreview() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _files.length,
      itemBuilder: (context, index) {
        File file = _files[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.file(file),
        );
      },
    );
  }

  Future<void> _pickFiles() async {
    if (_fileType == 'pdf') {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
      );

      if (result != null) {
        setState(() {
          _files = result.paths.map((path) => File(path!)).toList();
        });
      }
    } else {
      final pickedFiles = await picker.pickMultiImage();
      //removed null checker if statement.i dont know what would happen next
      setState(() {
        _files =
            pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
    }
  }

  Future<void> _uploadContent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_files.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one file')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      String contentId = const Uuid().v4();
      Map<String, String> fileUrls = {};

      for (File file in _files) {
        String fileName = file.path.split('/').last;
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child('groups/${widget.groupName}/content/$contentId/$fileName')
            .putFile(file);

        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        fileUrls[fileName] = downloadUrl;
      }

      DocumentSnapshot groupDoc = await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupName)
          .get();

      if (groupDoc.exists) {
        String ownerUid = groupDoc['owner'];
        CollectionReference contentCollection = FirebaseFirestore.instance
            .collection('groups')
            .doc(widget.groupName)
            .collection(currentUser.uid == ownerUid
                ? 'groupcontents'
                : 'contentrequests');

        await contentCollection.doc(contentId).set({
          'contentId': contentId,
          'postedby': currentUser.uid,
          'contentTitle': _title,
          'contentDescription': _description,
          'filetype': _fileType,
          'contentfiles': fileUrls,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Content uploaded successfully')),
        );

        setState(() {
          _isLoading = false;
        });

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Group not found')),
        );

        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
