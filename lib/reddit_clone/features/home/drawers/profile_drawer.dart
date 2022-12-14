import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/core/enums.dart';
import 'package:journal_riverpod/reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:journal_riverpod/reddit_clone/theme/theme.dart';
import 'package:journal_riverpod/reddit_clone/utils/style.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('u/$uid');
  }

  void toogleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toogleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          GestureDetector(
            onTap: () => navigateToUserProfile(context, user?.uid ?? ""),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user?.profilePic ?? ""),
              radius: 45,
            ),
          ),
          const SizedBox(
            height: kPading,
          ),
          Text(
            "u/${user?.name}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: kPading / 2,
          ),
          const Divider(),
          const SizedBox(
            height: kPading / 2,
          ),
          ListTile(
            title: const Text("Profile"),
            leading: const Icon(
              Icons.person,
            ),
            onTap: () {
              navigateToUserProfile(context, user?.uid ?? "");
            },
          ),
          ListTile(
            title: const Text("Log Out"),
            leading: const Icon(
              Icons.logout_outlined,
            ),
            onTap: () {
              logout(ref);
            },
          ),
          Switch.adaptive(
              value: ref.watch(themeNotifierProvider.notifier).mode ==
                  ThemeModes.dark,
              onChanged: (val) => toogleTheme(ref))
        ],
      )),
    );
  }
}
