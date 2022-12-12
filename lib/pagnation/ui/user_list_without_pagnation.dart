import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/pagnation/riverpod/user_notifier.dart';
import 'package:journal_riverpod/reddit_clone/widget/error_text.dart';
import 'package:journal_riverpod/reddit_clone/widget/loading_widget.dart';

class UserListWithoutPagnationScreen extends ConsumerStatefulWidget {
  const UserListWithoutPagnationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserListWithoutPagnationScreenState();
}

class _UserListWithoutPagnationScreenState
    extends ConsumerState<UserListWithoutPagnationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(userNotifierProvider(1).notifier).getListUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userNotifier = ref.watch(userNotifierProvider(1));
    return Scaffold(
      appBar: AppBar(
        title: const Text("User List"),
      ),
      body: userNotifier.when(
        initial: () => const SizedBox(),
        loading: () => const LoadingWidget(),
        success: (data) {
          return ListView.builder(
            itemCount: data?.data?.length,
            itemBuilder: (context, index) {
              var user = data?.data?[index];
              return ListTile(
                title: Text(user?.firstName ?? ""),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user?.avatar ?? ""),
                  radius: 30,
                ),
                subtitle: Text(user?.email ?? ""),
              );
            },
          );
        },
        error: (error) => ErrorText(
          error: error ?? "",
        ),
      ),
    );
  }
}
