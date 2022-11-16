import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/http_riverpod/model/user.dart';
import 'package:journal_riverpod/http_riverpod/service/service.dart';

final userDataProvider = FutureProvider<List<User>>((ref) async {
  return ref.watch(serviceProvider).getUser();
});
