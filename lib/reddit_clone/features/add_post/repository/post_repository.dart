import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:journal_riverpod/reddit_clone/models/comment.dart';
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

  void upVotes(Post post, String userId) async {
    if (post.downvotes.contains(userId)) {
      _post.doc(post.id).update({
        "downvotes": FieldValue.arrayRemove([userId])
      });
    }

    if (post.upvotes.contains(userId)) {
      _post.doc(post.id).update({
        "upvotes": FieldValue.arrayRemove([userId])
      });
    } else {
      _post.doc(post.id).update({
        "upvotes": FieldValue.arrayUnion([userId])
      });
    }
  }

  void downVotes(Post post, String userId) async {
    if (post.upvotes.contains(userId)) {
      _post.doc(post.id).update({
        "upvotes": FieldValue.arrayRemove([userId])
      });
    }

    if (post.downvotes.contains(userId)) {
      _post.doc(post.id).update({
        "downvotes": FieldValue.arrayRemove([userId])
      });
    } else {
      _post.doc(post.id).update({
        "downvotes": FieldValue.arrayUnion([userId])
      });
    }
  }

  Stream<Post> getPostById(String postId) {
    return _post
        .doc(postId)
        .snapshots()
        .map((event) => Post.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid addComment(Comment comment) async {
    try {
      return right(_comments.doc(comment.id).set(comment.toMap()));
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Stream<List<Comment>> getComments(String postId) {
    return _comments
        .where('postId', isEqualTo: postId)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Comment.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  CollectionReference get _post =>
      _firestore.collection(FirebaseConstants.postCollection);
  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);
}

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(firestore: ref.watch(firestoreProvider));
});
