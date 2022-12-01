import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:journal_riverpod/reddit_clone/core/provider/firebase_provider.dart';
import 'package:journal_riverpod/reddit_clone/models/user_model.dart';
import 'package:journal_riverpod/reddit_clone/utils/firebase_constants.dart';

import '../../../core/failure.dart';
import '../../../core/type_defs.dart';
import '../../../models/post_model.dart';

class UserProfileRepository {
  final FirebaseFirestore _firestore;

  UserProfileRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  CollectionReference get _userCollection =>
      _firestore.collection(FirebaseConstants.userCollection);
  CollectionReference get _post =>
      _firestore.collection(FirebaseConstants.postCollection);

  FutureVoid editProfile(UserModel userModel) async {
    try {
      return right(
          _userCollection.doc(userModel.uid).update(userModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Stream<List<Post>> getUserPost(String uid) {
    return _post
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
              .toList(),
        );
  }
}

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository(firestore: ref.watch(firestoreProvider));
});
