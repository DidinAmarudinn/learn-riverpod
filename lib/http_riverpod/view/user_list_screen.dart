import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/http_riverpod/view_model/data_provider.dart';

class UserListScreen extends ConsumerWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(userDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("RiverPod "),
      ),
      body: data.when(
        data: (val) {
          return ListView.builder(
              itemCount: val.length,
              itemBuilder: (context, index) {
                var user = val[index];
                return ListTile(
                  title: Text(user.firstName ?? ""),
                );
              });
        },
        error: (err, s) {
          return Text(err.toString());
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
