import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/features/community/controller/community_controller.dart';
import 'package:journal_riverpod/reddit_clone/features/community/screens/create_community_screen.dart';
import 'package:journal_riverpod/reddit_clone/widget/error_text.dart';
import 'package:journal_riverpod/reddit_clone/widget/loading_widget.dart';
import 'package:routemaster/routemaster.dart';

class CommunityDrawer extends ConsumerWidget {
  const CommunityDrawer({super.key});

  void navigagteToCommunity(BuildContext context, String name) {
    Routemaster.of(context).push('/r/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text("Create a community"),
              leading: const Icon(
                Icons.add,
              ),
              onTap: () {
                Routemaster.of(context).push(CreateCommunityScreen.routeName);
              },
            ),
            ref.watch(userCommunitiesProvider).when(
                  data: (data) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                        final community = data[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                          ),
                          title: Text("r/${community.name}"),
                          onTap: (){
                            navigagteToCommunity(context, community.name);
                          },
                        );
                      }),
                    );
                  },
                  error: (err, stacktrace) => ErrorText(
                    error: err.toString(),
                  ),
                  loading: () => const LoadingWidget(),
                )
          ],
        ),
      ),
    );
  }
}
