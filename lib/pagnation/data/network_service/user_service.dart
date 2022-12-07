import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/pagnation/common/exception.dart';
import 'package:journal_riverpod/pagnation/model/list_user_model.dart';
import 'package:http/http.dart' as http;

abstract class UserService {
  Future<ListUserModel?> getUserList(int page);
}

class UserServiceImpl extends UserService {
  final http.Client client;

  UserServiceImpl({required this.client});
  final baseUrl = "https://reqres.in";
  @override
  Future<ListUserModel?> getUserList(int page) async {
    final response =
        await client.get(Uri.parse("$baseUrl/api/users?page=$page"));
    if (response.statusCode == 200) {
      print(response.body);
      return ListUserModel.fromJson(json.decode(response.body));
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
