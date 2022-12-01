import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:journal_riverpod/reddit_clone/features/user_profile/repository/user_profile_repository.dart';
import 'package:journal_riverpod/reddit_clone/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/provider/storage_repository.dart';
import '../../../core/utils.dart';
import '../../../models/post_model.dart';

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _repository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  UserProfileController(
      {required UserProfileRepository repository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _repository = repository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editUserProfile({
    required File? profileFile,
    required File? bannerFile,
    required String name,
    required BuildContext context,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
        path: "users/profile",
        id: user.uid,
        file: profileFile,
      );
      res.fold((l) {
        showSnackBar(context, l.message);
      }, (url) {
        user = user.copyWith(profilePic: url);
      });
    }

    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
        path: "users/banner",
        id: user.uid,
        file: bannerFile,
      );
      res.fold((l) {
        showSnackBar(context, l.message);
      }, (url) {
        user = user.copyWith(banner: url);
      });
    }
    user = user.copyWith(name: name);
    final result = await _repository.editProfile(user);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update(
            (state) => user,
          );
      showSnackBar(context, "Success edit profile");
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Post>> getUserPost(String uid) {
    return _repository.getUserPost(uid);
  }
}

final userPforileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final communityRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
    repository: communityRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final getUserPostProvider = StreamProvider.family((ref, String uid) {
  final userProfileController =
      ref.watch(userPforileControllerProvider.notifier);
  return userProfileController.getUserPost(uid);
});
