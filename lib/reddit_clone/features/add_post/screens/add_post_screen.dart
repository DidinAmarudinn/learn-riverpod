import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/utils/style.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kPading, vertical: kPading / 2),
      child: Wrap(
        spacing: kPading / 2,
        runSpacing: kPading / 2,
        children: [
          _postCard(
            context,
            () {},
            Icons.image_outlined,
          ),
          _postCard(
            context,
            () {},
            Icons.font_download_outlined,
          ),
          _postCard(
            context,
            () {},
            Icons.link_outlined,
          ),
        ],
      ),
    ));
  }

  Widget _postCard(BuildContext context, Function onTap, IconData iconData) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: SizedBox(
        height: 130,
        width: 130,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  spreadRadius: 4,
                  blurRadius: 16,
                  offset: const Offset(0, 1),
                )
              ]),
          child: Center(
            child: Icon(
              iconData,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
