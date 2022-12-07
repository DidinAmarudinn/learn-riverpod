// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/features/add_post/controller/post_controller.dart';
import 'package:journal_riverpod/reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:journal_riverpod/reddit_clone/features/community/controller/community_controller.dart';

import 'package:journal_riverpod/reddit_clone/models/post_model.dart';
import 'package:journal_riverpod/reddit_clone/theme/theme.dart';
import 'package:journal_riverpod/reddit_clone/utils/image_constants.dart';
import 'package:journal_riverpod/reddit_clone/utils/style.dart';
import 'package:journal_riverpod/reddit_clone/widget/error_text.dart';
import 'package:journal_riverpod/reddit_clone/widget/loading_widget.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  void deletePost(context, WidgetRef ref) {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void upVotes(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).upVotes(post);
  }

  void downVotes(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).downVotes(post);
  }

  void navigateToUserProfile(BuildContext context) {
    Routemaster.of(context).push('u/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('r/${post.communityName}');
  }

  void navigateToComment(BuildContext context) {
    Routemaster.of(context).push('post/${post.id}/comments');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeLink = post.type == "Link";
    final isTypeImage = post.type == "Image";
    final isTypeText = post.type == "Text";
    final user = ref.watch(userProvider);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: kPading / 2),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                            horizontal: kPading, vertical: kPading / 4)
                        .copyWith(right: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => navigateToCommunity(context),
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(post.communityProfilePic),
                                radius: 20,
                              ),
                            ),
                            const SizedBox(
                              width: kPading / 3,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () => navigateToCommunity(context),
                                    child: Text(
                                      "r/${post.communityName}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: kPading / 5,
                                  ),
                                  GestureDetector(
                                    onTap: () => navigateToUserProfile(context),
                                    child: Text(
                                      "u/${post.username}",
                                      style: const TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (post.uid == user?.uid)
                              IconButton(
                                  onPressed: () {
                                    deletePost(context, ref);
                                  },
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: ThemeConfig.redColor,
                                  ))
                          ],
                        ),
                        const SizedBox(
                          height: kPading / 3,
                        ),
                        Text(
                          post.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: kPading / 2,
                        ),
                        if (isTypeImage)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  post.link!,
                                  fit: BoxFit.cover,
                                )),
                          ),
                        if (isTypeLink)
                          AnyLinkPreview(
                            link: post.link!,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                spreadRadius: 4,
                                blurRadius: 16,
                                offset: const Offset(0, 1),
                              )
                            ],
                            borderRadius: 4,
                            backgroundColor: Colors.white,
                            displayDirection: UIDirection.uiDirectionHorizontal,
                            bodyMaxLines: 8,
                          ),
                        if (isTypeText)
                          Text(
                            post.description ?? "",
                            style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.caption?.color),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    upVotes(ref);
                                  },
                                  icon: Icon(
                                    up,
                                    size: 30,
                                    color: post.upvotes.contains(user?.uid)
                                        ? ThemeConfig.blueColor
                                        : null,
                                  ),
                                ),
                                Text(
                                  "${post.upvotes.length - post.downvotes.length == 0 ? "Vote" : post.upvotes.length - post.downvotes.length}",
                                  style: const TextStyle(fontSize: 17),
                                ),
                                IconButton(
                                  onPressed: () {
                                    downVotes(ref);
                                  },
                                  icon: Icon(
                                    down,
                                    size: 30,
                                    color: post.downvotes.contains(user?.uid)
                                        ? ThemeConfig.redColor
                                        : null,
                                  ),
                                )
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                navigateToComment(context);
                              },
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.comment_outlined,
                                      size: 25,
                                    ),
                                  ),
                                  Text(
                                    "${post.commentCount == 0 ? "Comment" : post.commentCount}",
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                            ref
                                .watch(getCommunityByNameProvider(
                                    post.communityName))
                                .when(
                                  data: (data) {
                                    if (data.mods.contains(user?.uid)) {
                                      return IconButton(
                                        onPressed: () =>
                                            deletePost(context, ref),
                                        icon: const Icon(
                                          Icons.admin_panel_settings,
                                        ),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                  error: (error, stackTrace) => ErrorText(
                                    error: error.toString(),
                                  ),
                                  loading: () => const LoadingWidget(),
                                ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
        const SizedBox(
          height: kPading / 2,
        ),
      ],
    );
  }
}
