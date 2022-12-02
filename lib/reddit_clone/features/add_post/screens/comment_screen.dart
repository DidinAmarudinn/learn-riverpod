// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:journal_riverpod/reddit_clone/features/add_post/controller/post_controller.dart';
import 'package:journal_riverpod/reddit_clone/models/post_model.dart';
import 'package:journal_riverpod/reddit_clone/utils/style.dart';
import 'package:journal_riverpod/reddit_clone/widget/comment_card.dart';
import 'package:journal_riverpod/reddit_clone/widget/error_text.dart';
import 'package:journal_riverpod/reddit_clone/widget/loading_widget.dart';
import 'package:journal_riverpod/reddit_clone/widget/post_card.dart';
import 'package:journal_riverpod/reddit_clone/widget/textfield.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentScreen({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
        context: context, text: commentController.text.trim(), post: post);
    setState(() {
      commentController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
          data: (post) {
            return Column(
              children: [
                PostCard(post: post),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kPading),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFieldWidget(
                          controller: commentController,
                          hintText: "What are you thoughts?",
                          maxLines: 4,
                          minLines: 1,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          addComment(post);
                        },
                        icon: const Icon(
                          Icons.send_outlined,
                        ),
                      )
                    ],
                  ),
                ),
                ref.watch(getCommentsProvider(widget.postId)).when(
                      data: (data) {
                        return Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: kPading/2),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return CommentCard(comment: data[index]);
                            },
                          ),
                        );
                      },
                      error: (err, stackTrace) {
                        return ErrorText(error: err.toString());
                      },
                      loading: () => const LoadingWidget(),
                    ),
              ],
            );
          },
          error: (error, stackTrace) {
            return ErrorText(error: error.toString());
          },
          loading: () => const LoadingWidget()),
    );
  }
}
