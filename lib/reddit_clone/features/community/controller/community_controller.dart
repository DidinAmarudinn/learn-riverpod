import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/core/provider/storage_repository.dart';
import 'package:journal_riverpod/reddit_clone/core/utils.dart';
import 'package:journal_riverpod/reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:journal_riverpod/reddit_clone/features/community/repository/community_repository.dart';
import 'package:journal_riverpod/reddit_clone/models/community_model.dart';
import 'package:journal_riverpod/reddit_clone/utils/image_constants.dart';
import 'package:routemaster/routemaster.dart';

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _repository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  CommunityController(
      {required CommunityRepository repository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _repository = repository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createCommunity(String communityName, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? "";
    Community community = Community(
      id: communityName,
      name: communityName,
      banner: bannerDefault,
      avatar: avatarDefault,
      members: [uid],
      mods: [uid],
    );
    final result = await _repository.createCommunity(community);
    state = false;
    result.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      showSnackBar(context, "Community created successfully!");
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)?.uid ?? "";
    return _repository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _repository.getCommunityByName(name);
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _repository.searchCommunity(query);
  }
  void editCommunity({
    required File? profileFile,
    required File? bannerFile,
    required Community community,
    required BuildContext context,
  }) async {
    state = true;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
        path: "communities/profile",
        id: community.name,
        file: profileFile,
      );
      res.fold((l) {
        showSnackBar(context, l.message);
      }, (url) {
        community = community.copyWith(avatar: url);
      });
    }

    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
        path: "communities/banner",
        id: community.name,
        file: bannerFile,
      );
      res.fold((l) {
        showSnackBar(context, l.message);
      }, (url) {
       community = community.copyWith(banner: url);
      });
    }
    final result = await _repository.editCommunity(community);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, "Success edit community");
      Routemaster.of(context).pop();
    });
  }


}

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return CommunityController(
    repository: communityRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final searchCommunitiesProvider = StreamProvider.family((ref, String query) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.searchCommunity(query);
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getCommunityByName(name);
});
