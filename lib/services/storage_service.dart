//Ogounchi Christian 2401001673 24/09/2026

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadPostImage({
    required String userId,
    required File imageFile,
  }) async {
    final String fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${imageFile.uri.pathSegments.last}';
    final Reference imageRef = _storage.ref('posts/$userId/$fileName');

    try {
      await imageRef.putFile(imageFile);
      return await imageRef.getDownloadURL();
    } on FirebaseException catch (e) {
      throw StorageException(_messageFor(e.code));
    }
  }

  Future<void> deleteImage(String downloadUrl) async {
    try {
      await _storage.refFromURL(downloadUrl).delete();
    } on FirebaseException catch (e) {
      throw StorageException(_messageFor(e.code));
    }
  }

  String _messageFor(String code) {
    switch (code) {
      case 'unauthorized':
        return 'You do not have permission to upload images.';
      case 'canceled':
        return 'Image upload was canceled.';
      case 'retry-limit-exceeded':
        return 'Image upload failed. Please try again.';
      default:
        return 'Something went wrong while uploading the image.';
    }
  }
}

class StorageException implements Exception {
  final String message;

  const StorageException(this.message);

  @override
  String toString() => message;
}