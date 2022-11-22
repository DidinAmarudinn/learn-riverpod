// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/core/utils.dart';
import 'package:journal_riverpod/reddit_clone/features/auth/repositroy/auth_repository.dart';

class AuthController {
  final AuthRepository _authRepository;
  AuthController({
    required AuthRepository repository,
  }) : _authRepository = repository;

  void signInWithGoogle(BuildContext context) async {
    final user = await _authRepository.signInWithGoogle();
    user.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      
    });
  }
}

final authControllerProvider = Provider<AuthController>(
  (ref) => AuthController(
    repository: ref.read(authRepositoryProvider),
  ),
);
