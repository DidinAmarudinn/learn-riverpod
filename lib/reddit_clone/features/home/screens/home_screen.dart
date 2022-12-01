import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/core/utils.dart';
import 'package:journal_riverpod/reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:journal_riverpod/reddit_clone/features/home/delegate/search_community_delegate.dart';
import 'package:journal_riverpod/reddit_clone/features/home/drawers/community_drawer.dart';
import 'package:journal_riverpod/reddit_clone/features/home/drawers/profile_drawer.dart';

import '../../../theme/theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    final indexPage = ref.watch(indexPageProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Home",
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          leading: Builder(builder: (context) {
            return IconButton(
              onPressed: () => displayDrawer(context),
              icon: const Icon(
                Icons.menu,
              ),
            );
          }),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                    context: context, delegate: SearchCommunityDelegate(ref));
              },
              icon: const Icon(
                Icons.search,
              ),
            ),
            Builder(builder: (context) {
              return IconButton(
                onPressed: () => displayEndDrawer(context),
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user?.profilePic ?? ""),
                ),
              );
            })
          ],
          centerTitle: false,
        ),
        drawer: const CommunityDrawer(),
        endDrawer: const ProfileDrawer(),
        bottomNavigationBar: CupertinoTabBar(
          activeColor: currentTheme.iconTheme.color,
          currentIndex: indexPage,
          backgroundColor: currentTheme.backgroundColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
              ),
            ),
          ],
          onTap: (val) {
            ref.read(indexPageProvider.notifier).state = val;
          },
        ),
        body: tabWidgets[indexPage]);
  }
}
