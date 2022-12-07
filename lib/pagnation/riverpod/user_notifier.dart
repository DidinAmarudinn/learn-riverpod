import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/pagnation/core/request_state.dart';
import 'package:journal_riverpod/pagnation/data/repository/user_repository.dart';
import 'package:journal_riverpod/pagnation/model/list_user_model.dart';

class UserNotifier extends StateNotifier<RequestState<ListUserModel?>> {
  final UserRepository repository;
  final int page;
  UserNotifier({
    required this.repository,
    required this.page,
  }) : super(const RequestState.initial());

  Future<void> getListUser() async {
    state = const RequestState.loading();
    final result = await repository.getUserList(page);
    result.fold((failure) {
      state = RequestState.error(failure.message);
    }, (userList) {
      state = RequestState.success(userList);
    });
  }
}

final userNotifierProvider =
    StateNotifierProvider.family<UserNotifier, RequestState<ListUserModel?>, int>(
  (ref, int page) {
    return UserNotifier(
      page: 0,
      repository: ref.watch(
        userRepositoryProvider,
      ),
    );
  },
);


