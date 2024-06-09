import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//this methode is for pick the image from the gallery or camera

pickImage(ImageSource source) async {
  //create an instance of image picker
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);

  //check there is a image
  if (file != null) {
    //return the image
    return await file.readAsBytes();
  }
  print("no image selected");
}

//snakbar

showSnakBar(BuildContext context, String res) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(res),
    ),
  );
}

//timer fomat

String formatDuration(int totalSeconds) {
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  final seconds = totalSeconds % 60;

  return '${hours}h ${minutes}min ${seconds}sec';
}
