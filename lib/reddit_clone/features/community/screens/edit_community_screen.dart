import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/core/utils.dart';
import 'package:journal_riverpod/reddit_clone/features/community/controller/community_controller.dart';
import 'package:journal_riverpod/reddit_clone/models/community_model.dart';
import 'package:journal_riverpod/reddit_clone/theme/theme.dart';
import 'package:journal_riverpod/reddit_clone/utils/image_constants.dart';
import 'package:journal_riverpod/reddit_clone/utils/style.dart';
import 'package:journal_riverpod/reddit_clone/widget/error_text.dart';
import 'package:journal_riverpod/reddit_clone/widget/loading_widget.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      bannerFile = File(res.files.first.path!);
      setState(() {});
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      profileFile = File(res.files.first.path!);
      setState(() {});
    }
  }

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
        profileFile: profileFile,
        bannerFile: bannerFile,
        community: community,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
        data: (community) {
      return Scaffold(
        backgroundColor: currentTheme.backgroundColor,
        appBar: AppBar(
          title: Text(
            "Edit Community",
            style: TextStyle(
              color: currentTheme.textTheme.titleLarge?.color,
            ),
          ),
          centerTitle: false,
          actions: [
            TextButton(
              onPressed: () {
                save(community);
              },
              child: const Text("Save"),
            ),
          ],
        ),
        body: isLoading
            ? const LoadingWidget()
            : Padding(
                padding: const EdgeInsets.all(kPading / 2),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: selectBannerImage,
                            child: DottedBorder(
                              radius: const Radius.circular(10),
                              dashPattern: const [10, 4],
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              color: currentTheme.textTheme.bodyText2!.color!,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: bannerFile != null
                                    ? Image.file(
                                        bannerFile!,
                                        fit: BoxFit.cover,
                                      )
                                    : community.banner.isEmpty ||
                                            community.banner == bannerDefault
                                        ? const Center(
                                            child: Icon(
                                              Icons.camera_alt_rounded,
                                              size: 40,
                                            ),
                                          )
                                        : Image.network(
                                            community.banner,
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: GestureDetector(
                              onTap: selectProfileImage,
                              child: profileFile != null
                                  ? CircleAvatar(
                                      radius: 32,
                                      backgroundImage: FileImage(profileFile!),
                                    )
                                  : CircleAvatar(
                                      radius: 32,
                                      backgroundImage:
                                          NetworkImage(community.avatar),
                                    ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
      );
    }, error: (error, stackTrace) {
      return ErrorText(error: error.toString());
    }, loading: () {
      return const LoadingWidget();
    });
  }
}
