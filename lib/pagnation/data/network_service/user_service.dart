import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/pagnation/common/exception.dart';
import 'package:journal_riverpod/pagnation/model/list_user_dummy_model.dart';
import 'package:journal_riverpod/pagnation/model/list_user_model.dart';
import 'package:http/http.dart' as http;

abstract class UserService {
  Future<ListUserModel?> getUserList(int page);
  Future<UserFakeModel?> getUserListDummy(int page);
}

class UserServiceImpl extends UserService {
  final http.Client client;

  UserServiceImpl({required this.client});
  var baseUrl = "https://reqres.in";
  var baseUrlDummy = "https://dummyapi.io/data/v1";
  @override
  Future<ListUserModel?> getUserList(int page) async {
    final response = await client
        .get(Uri.parse("$baseUrl/api/users?page=$page&per_page=10"));
    if (response.statusCode == 200) {
      return ListUserModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserFakeModel?> getUserListDummy(int page) async {
    final response = await http.get(
      Uri.parse("$baseUrlDummy/user?page=$page"),
      headers: {
        "app-id": "639057ff78f790a934af975b",
      },
    );
    if (response.statusCode == 200) {
      return UserFakeModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}

final userServiceProvider = Provider<UserService>((ref) {
  return UserServiceImpl(client: ref.read(httpProviderProvider));
});

final httpProviderProvider = Provider<http.Client>((ref) {
  return http.Client();
});
