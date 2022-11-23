import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:journal_riverpod/reddit_clone/core/failure.dart';
import 'package:journal_riverpod/reddit_clone/core/provider/firebase_provider.dart';
import 'package:journal_riverpod/reddit_clone/core/type_defs.dart';
import 'package:journal_riverpod/reddit_clone/models/community_model.dart';
import 'package:journal_riverpod/reddit_clone/utils/firebase_constants.dart';

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communities.doc(community.name).get();
      if (communityDoc.exists) {
        throw "Community with same name already exsist";
      }
      return Right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      return Left(Failure(message: e.message ?? ""));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
}

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepository(firestore: ref.watch(firestoreProvider));
});