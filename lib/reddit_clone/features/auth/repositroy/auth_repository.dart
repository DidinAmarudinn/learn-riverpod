// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:journal_riverpod/reddit_clone/core/failure.dart';
import 'package:journal_riverpod/reddit_clone/core/provider/firebase_provider.dart';
import 'package:journal_riverpod/reddit_clone/core/type_defs.dart';
import 'package:journal_riverpod/reddit_clone/models/user_model.dart';
import 'package:journal_riverpod/reddit_clone/utils/firebase_constants.dart';
import 'package:journal_riverpod/reddit_clone/utils/image_constants.dart';

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _user =>
      _firestore.collection(FirebaseConstants.userCollection);

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      late UserModel userModel;
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        userModel = UserModel(
          name: userCredential.user?.displayName ?? "No Name",
          profilePic: userCredential.user?.photoURL ?? "",
          banner: bannerDefault,
          uid: userCredential.user?.uid ?? "",
          isAuthenticated: true,
          karma: 0,
          awards: [],
        );
        await _user.doc(userCredential.user?.uid ?? "").set(userModel.toMap());
      } else {
       userModel = await getUserData(userCredential.user?.uid ?? "").first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message ?? "";
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
  Stream<UserModel> getUserData(String uid) {
    return _user.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  );
});
