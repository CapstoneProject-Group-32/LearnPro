import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FilePickerButton extends StatefulWidget {
  const FilePickerButton({super.key});

  @override
  _FilePickerButtonState createState() => _FilePickerButtonState();
}

class _FilePickerButtonState extends State<FilePickerButton> {
  String? _fileName;
  String? _filePath;
  int? _fileSize;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      // The storage permission is granted.
    } else if (status.isDenied) {
      // Handle the case when the permission is denied.
    } else if (status.isPermanentlyDenied) {
      // Handle the case when the permission is permanently denied.
      await openAppSettings();
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        _fileName = file.name;
        _filePath = file.path;
        _fileSize = file.size;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 300,
            child: ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Pick a PDF file'),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (_fileName != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.picture_as_pdf),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('File Name: $_fileName'),
                    Text('File Size: $_fileSize bytes'),
                    Text('File Path: $_filePath'),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
