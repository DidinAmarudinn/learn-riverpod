import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/features/add_post/controller/post_controller.dart';
import 'package:journal_riverpod/reddit_clone/features/community/controller/community_controller.dart';
import 'package:journal_riverpod/reddit_clone/widget/error_text.dart';
import 'package:journal_riverpod/reddit_clone/widget/loading_widget.dart';
import 'package:journal_riverpod/reddit_clone/widget/post_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userCommunitiesProvider).when(
          data: (communitites) {
            return ref.watch(userPostsProvider(communitites)).when(
                  data: (data) {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final post = data[index];

                        return PostCard(post: post);
                      },
                    );
                  },
                  error: (err, stackTrace) {
                    return ErrorText(error: err.toString());
                  },
                  loading: () => const LoadingWidget(),
                );
          },
          error: (err, stackTrace) => ErrorText(error: err.toString()),
          loading: () => const LoadingWidget(),
        );
  }
}
