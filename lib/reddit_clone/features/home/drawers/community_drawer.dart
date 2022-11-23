import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/features/community/screens/community_screen.dart';
import 'package:routemaster/routemaster.dart';

class CommunityDrawer extends ConsumerWidget {
  const CommunityDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children:  [
            ListTile(
              title: const Text("Create a community"),
              leading: const Icon(Icons.add,),
              onTap: (){
                Routemaster.of(context).push(CreateCommunityScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
