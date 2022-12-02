import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/core/utils.dart';
import 'package:journal_riverpod/reddit_clone/features/add_post/repository/post_repository.dart';
import 'package:journal_riverpod/reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:journal_riverpod/reddit_clone/models/comment.dart';
import 'package:journal_riverpod/reddit_clone/models/community_model.dart';
import 'package:journal_riverpod/reddit_clone/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/provider/storage_repository.dart';

class PostController extends StateNotifier<bool> {
  final PostRepository _repository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  PostController(
      {required PostRepository repository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _repository = repository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareTextPost(
      {required BuildContext context,
      required String title,
      required String desc,
      required Community community}) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider);
    final post = Post(
      id: postId,
      title: title,
      communityName: community.name,
      communityProfilePic: community.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user?.name ?? "",
      uid: user?.uid ?? "",
      type: "Text",
      createdAt: DateTime.now(),
      awards: [],
      description: desc,
    );

    final result = await _repository.addPost(post);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, "Posted successfully!");
      Routemaster.of(context).pop();
    });
  }

  void shareLinkPost(
      {required BuildContext context,
      required String title,
      required String link,
      required Community community}) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider);
    final post = Post(
      id: postId,
      title: title,
      communityName: community.name,
      communityProfilePic: community.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user?.name ?? "",
      uid: user?.uid ?? "",
      type: "Link",
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );

    final result = await _repository.addPost(post);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, "Posted successfully!");
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost(
      {required BuildContext context,
      required String title,
      required File image,
      required Community community}) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider);
    final imageResult = await _storageRepository.storeFile(
        path: "posts/${community.name}", id: postId, file: image);
    imageResult.fold((l) => showSnackBar(context, l.message), (r) async {
      final post = Post(
        id: postId,
        title: title,
        communityName: community.name,
        communityProfilePic: community.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user?.name ?? "",
        uid: user?.uid ?? "",
        type: "Image",
        createdAt: DateTime.now(),
        awards: [],
        link: r,
      );

      final result = await _repository.addPost(post);
      state = false;
      result.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, "Posted successfully!");
        Routemaster.of(context).pop();
      });
    });
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _repository.fetchUserPosts(communities);
    } else {
      return Stream.value([]);
    }
  }

  void deletePost(Post post, BuildContext context) async {
    final res = await _repository.deletePost(post);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, "Success delete post");
    });
  }

  void upVotes(Post post) async {
    final userId = _ref.read(userProvider)?.uid ?? "";
    _repository.upVotes(post, userId);
  }

  void downVotes(Post post) async {
    final userId = _ref.read(userProvider)?.uid ?? "";
    _repository.downVotes(post, userId);
  }

  void addComment({
    required BuildContext context,
    required String text,
    required Post post,
  }) async {
    final user = _ref.read(userProvider);
    String id = const Uuid().v1();
    Comment comment = Comment(
      id: id,
      text: text,
      createdAt: DateTime.now(),
      postId: post.id,
      userName: user?.name ?? "",
      profilePic: user?.profilePic ?? "",
      userId: user?.uid ?? "",
    );

    final res = await _repository.addComment(comment);
    res.fold((l) => showSnackBar(context, l.message),
        (r) => showSnackBar(context, "Comment send successfully!"));
  }

  Stream<Post> getPostById(String postId) {
    return _repository.getPostById(postId);
  }

  Stream<List<Comment>> getComments(String postId) {
    return _repository.getComments(postId);
  }
}

final postControllerProvider = StateNotifierProvider<PostController, bool>(
  (ref) {
    final postRepository = ref.watch(postRepositoryProvider);
    final storageRepository = ref.watch(storageRepositoryProvider);
    return PostController(
      repository: postRepository,
      ref: ref,
      storageRepository: storageRepository,
    );
  },
);

final userPostsProvider =
    StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});

final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostById(postId);
});


final getCommentsProvider = StreamProvider.family((ref, String postId)  {
   final postController = ref.watch(postControllerProvider.notifier);
  return postController.getComments(postId);
});