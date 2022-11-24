import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:journal_riverpod/reddit_clone/features/home/delegate/search_community_delegate.dart';
import 'package:journal_riverpod/reddit_clone/features/home/drawers/community_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => displayDrawer(context),
              icon: const Icon(
                Icons.menu,
              ),
            );
          }
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchCommunityDelegate(ref));
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              backgroundImage: NetworkImage(user?.profilePic ?? ""),
            ),
          )
        ],
        centerTitle: false,
      ),
      drawer: const CommunityDrawer(),
      body: Center(
        child: Text(user?.name ?? ""),
      ),
    );
  }
}
