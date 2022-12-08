import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:journal_riverpod/pagnation/core/request_pagnation_state.dart';
import 'package:journal_riverpod/pagnation/data/repository/user_repository.dart';
import 'package:journal_riverpod/pagnation/model/list_user_dummy_model.dart';
import 'package:journal_riverpod/pagnation/model/list_user_model.dart';
import 'package:journal_riverpod/reddit_clone/core/failure.dart';

class PaginationNotifier<T> extends StateNotifier<RequestPagnationState<T>> {
  PaginationNotifier({
    required this.fetchNextItems,
    required this.itemsPerBatch,
  }) : super(const RequestPagnationState.loading());

  final Future<Either<Failure, List<T>>> Function(int page) fetchNextItems;
  final int itemsPerBatch;

  final List<T> _items = [];

  Timer _timer = Timer(const Duration(milliseconds: 0), () {});

  bool noMoreItems = false;
  int page = 0;
  void init() {
    if (_items.isEmpty) {
      fetchFirstBatch();
    }
  }

  void updateData(List<T> result) {
    noMoreItems = result.length < itemsPerBatch;

    if (result.isEmpty) {
      state = RequestPagnationState.data(_items);
    } else {
      state = RequestPagnationState.data(_items..addAll(result));
    }
    page++;
  }

  Future<void> fetchFirstBatch() async {
    print("object");
    try {
      state = const RequestPagnationState.loading();
      final result = await fetchNextItems(page);
      result.fold((l) {
        state = RequestPagnationState.error(l.message);
      }, (list) {
        final List<T> result = list;
        updateData(result);
      });
    } catch (e) {
      state = RequestPagnationState.error(e.toString());
    }
  }

  Future<void> fetchNextBatch() async {
    if (_timer.isActive && _items.isNotEmpty) {
      return;
    }
    _timer = Timer(const Duration(milliseconds: 1000), () {});

    if (noMoreItems) {
      return;
    }

    if (state == RequestPagnationState<T>.onGoingLoading(_items)) {
      return;
    }

    state = RequestPagnationState.onGoingLoading(_items);

    await Future.delayed(const Duration(seconds: 1));
    final result = await fetchNextItems(page);
    result.fold((l) {
      state = RequestPagnationState.onGoingError(_items, l.message);
    }, (list) {
      updateData(list);
    });
  }
}

final itemsProvider = StateNotifierProvider<PaginationNotifier<Data>,
    RequestPagnationState<Data>>((ref) {
  return PaginationNotifier(
    itemsPerBatch: 6,
    fetchNextItems: (page) {
      return ref.read(userRepositoryProvider).getUserListPagnation(page);
    },
  )..init();
});

final itemsFakeUserProvider = StateNotifierProvider<
    PaginationNotifier<UserData>, RequestPagnationState<UserData>>((ref) {
  return PaginationNotifier(
    fetchNextItems: (page) {
      return ref.read(userRepositoryProvider).getFakeUser(page);
    },
    itemsPerBatch: 10,
  )..init();
});
