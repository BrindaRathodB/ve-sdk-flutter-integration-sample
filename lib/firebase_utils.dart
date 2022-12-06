import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseUtils {
  // upload takes video to storage
  static Future<String?> uploadTakesVideoToStorage(File fileV) async {
    final originalFileRef =
        FirebaseStorage.instance.ref('test').child("fileName");

    try {
      print("uploadTakesVideoToStorage before putFile");

      // upload the original image
      await originalFileRef.putFile(
          fileV, SettableMetadata(contentType: 'video/mp4'));
      print("uploadTakesVideoToStorage after putFile");

      await originalFileRef.getDownloadURL().then((value) {
        print("uploadTakesVideoToStorage getDownloadURL $value");
        return value;
      });
    } catch (err) {
      print("err $err");
    }
    return null;
  }
}
