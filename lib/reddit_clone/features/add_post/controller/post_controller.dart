import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/core/utils.dart';
import 'package:journal_riverpod/reddit_clone/features/add_post/repository/post_repository.dart';
import 'package:journal_riverpod/reddit_clone/features/auth/controller/auth_controller.dart';
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
      communityProfilePict: community.avatar,
      upVotes: [],
      downVotes: [],
      commentCount: 0,
      username: user?.name ?? "",
      uid: user?.uid ?? "",
      type: "Text",
      createdAt: DateTime.now(),
      awards: [],
      desc: desc,
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
      communityProfilePict: community.avatar,
      upVotes: [],
      downVotes: [],
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
        communityProfilePict: community.avatar,
        upVotes: [],
        downVotes: [],
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