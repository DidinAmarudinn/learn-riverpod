import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:journal_riverpod/reddit_clone/core/failure.dart';
import 'package:journal_riverpod/reddit_clone/core/provider/firebase_provider.dart';
import 'package:journal_riverpod/reddit_clone/core/type_defs.dart';

class StorageRepository {
  final FirebaseStorage _firebaseStorage;
  StorageRepository({
    required FirebaseStorage firebaseStorage,
  }) : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File? file,
  }) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      UploadTask uploadTask = ref.putFile(file!);
      final snapshot = await uploadTask;
      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return StorageRepository(firebaseStorage: ref.watch(storageProvider));
});