import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/core/utils.dart';
import 'package:journal_riverpod/reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:journal_riverpod/reddit_clone/features/community/repository/community_repository.dart';
import 'package:journal_riverpod/reddit_clone/models/community_model.dart';
import 'package:journal_riverpod/reddit_clone/utils/image_constants.dart';
import 'package:routemaster/routemaster.dart';

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _repository;
  final Ref _ref;
  CommunityController(
      {required CommunityRepository repository, required Ref ref})
      : _repository = repository,
        _ref = ref,
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
}

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  return CommunityController(repository: communityRepository, ref: ref);
});

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getCommunityByName(name);
});
