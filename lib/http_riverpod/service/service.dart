import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:journal_riverpod/http_riverpod/model/user.dart';

class Service {
  String endpoint = "https://reqres.in/api/users?page=2";


  Future<List<User>> getUser() async {
    Response response = await get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      final List result = json.decode(response.body)["data"]; 
      return result.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}

final serviceProvider = Provider<Service>((ref)=> Service());