// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:journal_riverpod/reddit_clone/features/community/controller/community_controller.dart';
import 'package:journal_riverpod/reddit_clone/widget/error_text.dart';
import 'package:journal_riverpod/reddit_clone/widget/loading_widget.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModsScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> uids = {};
  int ctr = 0;
  void addUids(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUids(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void addMods() {
    ref.read(communityControllerProvider.notifier).addMods(
          widget.name,
          context,
          uids.toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Mods"),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              addMods();
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) {
            return ListView.builder(
              itemCount: community.members.length,
              itemBuilder: (context, index) {
                final members = community.members[index];
                return ref.watch(getUserDataProvider(members)).when(
                    data: (user) {
                      if (community.mods.contains(members) && ctr == 0) {
                        uids.add(members);
                      }
                      ctr++;
                      return CheckboxListTile(
                        value: uids.contains(members),
                        title: Text(user.name),
                        onChanged: (val) {
                          if (val!) {
                            addUids(members);
                          } else {
                            removeUids(members);
                          }
                        },
                      );
                    },
                    error: (err, stackTrace) {
                      return ErrorText(error: err.toString());
                    },
                    loading: () => const LoadingWidget());
              },
            );
          },
          error: (err, stackTrace) {
            return ErrorText(error: err.toString());
          },
          loading: () => const LoadingWidget()),
    );
  }
}
