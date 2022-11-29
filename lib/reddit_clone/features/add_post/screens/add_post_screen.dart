import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/utils/style.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToType(BuildContext context,String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

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
            (){
              navigateToType(context, "Image");
            },
            Icons.image_outlined,
          ),
          _postCard(
            context,
            () {
               navigateToType(context, "Text");
            },
            Icons.font_download_outlined,
          ),
          _postCard(
            context,
            () {
               navigateToType(context, "Link");
            },
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
