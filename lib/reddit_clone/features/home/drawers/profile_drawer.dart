import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:journal_riverpod/reddit_clone/utils/style.dart';


class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user?.profilePic ?? ""),
            radius: 45,
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
            title: const Text("My Profile"),
            leading: const Icon(
              Icons.person,
            ),
            onTap: () {
            },
          ),
          ListTile(
            title: const Text("Logout"),
            leading: const Icon(
              Icons.logout_outlined,
            ),
            onTap: () {
              logout(ref);
            },
          ),
          Switch.adaptive(value: true, onChanged: (val){})
        ],
      )),
    );
  }
}
