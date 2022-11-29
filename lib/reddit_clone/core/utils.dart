import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/features/add_post/screens/add_post_screen.dart';
import 'package:journal_riverpod/reddit_clone/features/feed/screens/fedd_screen.dart';
import 'package:journal_riverpod/reddit_clone/models/community_model.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
}

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(type: FileType.image);
  return image;
}

const tabWidgets = [
  FeedScreen(),
  AddPostScreen(),
];

final indexPageProvider = StateProvider((ref) {
  return 0;
});

final selectCommunityProvider = StateProvider<Community?>((ref){
  return null;
});

