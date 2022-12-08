import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:journal_riverpod/pagnation/common/exception.dart';
import 'package:journal_riverpod/pagnation/data/network_service/user_service.dart';
import 'package:journal_riverpod/pagnation/model/list_post_fake_model.dart';
import 'package:journal_riverpod/pagnation/model/list_user_dummy_model.dart';
import 'package:journal_riverpod/pagnation/model/list_user_model.dart';
import 'package:journal_riverpod/reddit_clone/core/failure.dart';

abstract class UserRepository {
  Future<Either<Failure, ListUserModel?>> getUserList(int page);
  Future<Either<Failure, List<Data>>> getUserListPagnation(int page);
  Future<Either<Failure, List<UserData>>> getFakeUser(int page);
  Future<Either<Failure, List<PostData>>> getFakePosts(int page, int limit);
}

class UserRepositoryImpl extends UserRepository {
  final UserService service;

  UserRepositoryImpl({required this.service});
  @override
  Future<Either<Failure, ListUserModel?>> getUserList(int page) async {
    try {
      final result = await service.getUserList(page);
      return right(result);
    } on ServerException {
      return left(Failure(message: "Internal Server Error"));
    } on SocketException {
      return left(Failure(message: "Failled connect to the network"));
    }
  }

  @override
  Future<Either<Failure, List<Data>>> getUserListPagnation(int page) async {
    try {
      final result = await service.getUserList(page);
      return right(result?.data ?? []);
    } on ServerException {
      return left(Failure(message: "Internal Server Error"));
    } on SocketException {
      return left(Failure(message: "Failled connect to the network"));
    }
  }

  @override
  Future<Either<Failure, List<UserData>>> getFakeUser(int page) async {
    try {
      final result = await service.getUserListDummy(page);
      return right(result?.data ?? []);
    } on ServerException {
      return left(Failure(message: "Internal Server Error"));
    } on SocketException {
      return left(Failure(message: "Failled connect to the network"));
    }
  }

  @override
  Future<Either<Failure, List<PostData>>> getFakePosts(int page, int limit) async {
    try {
      final result = await service.getPostListDummy(page, limit);
      return right(result?.data ?? []);
    } on ServerException {
      return left(Failure(message: "Internal Server Error"));
    } on SocketException {
      return left(Failure(message: "Failled connect to the network"));
    }
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(service: ref.watch(userServiceProvider));
});
