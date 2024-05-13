import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  //create a storage instance

  final FirebaseStorage _storage = FirebaseStorage.instance;

  //firebase instance

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //function for store the picture to the storage and return the URL

  Future<String> uploadImage({
    required String folderName,
    required bool isFile,
    required Uint8List file,
  }) async {
    //create a referance for the image here we also select the correct folder
    Reference ref = _storage.ref(folderName).child(_auth.currentUser!.uid);

    //if this is a file add another id

    if (isFile) {
      String fileId = const Uuid().v4();

      ref = ref.child(fileId);
    }

    //file id >> pdf >> fileId >>

    //upload the image to storage

    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();

    return downloadURL;
  }
}
