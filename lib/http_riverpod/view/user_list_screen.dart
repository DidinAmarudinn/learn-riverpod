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
                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, 4),
                        blurRadius: 40,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              user.avatar ?? "",
                              width: 30,
                              height: 30,
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Text(user.firstName ?? "")
                        ],
                      ),
                      const SizedBox(height: 12,),
                      Text(user.email ?? "")
                    ],
                  ),
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
