import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:journal_riverpod/reddit_clone/models/post_model.dart';
import 'package:journal_riverpod/reddit_clone/utils/firebase_constants.dart';

import '../../../core/failure.dart';
import '../../../core/provider/firebase_provider.dart';
import '../../../core/type_defs.dart';
import '../../../models/community_model.dart';

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid addPost(Post post) async {
    try {
      return right(_post.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    return _post
        .where('communityName',
            whereIn: communities.map((e) => e.name).toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(_post.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  CollectionReference get _post =>
      _firestore.collection(FirebaseConstants.postCollection);
}

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(firestore: ref.watch(firestoreProvider));
});
