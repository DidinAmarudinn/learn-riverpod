import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/features/add_post/controller/post_controller.dart';
import 'package:journal_riverpod/reddit_clone/features/community/controller/community_controller.dart';
import 'package:journal_riverpod/reddit_clone/models/community_model.dart';
import 'package:journal_riverpod/reddit_clone/utils/style.dart';
import 'package:journal_riverpod/reddit_clone/widget/error_text.dart';
import 'package:journal_riverpod/reddit_clone/widget/loading_widget.dart';
import 'package:journal_riverpod/reddit_clone/widget/textfield.dart';

import '../../../core/utils.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  late bool isTypeLink;
  late bool isTypeImage;
  List<Community> _communities = [];
  late bool isTypeText;
  File? bannerFile;

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      bannerFile = File(res.files.first.path!);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getType();
  }

  void getType() {
    isTypeLink = widget.type == "Link";
    isTypeImage = widget.type == "Image";
    isTypeText = widget.type == "Text";
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  void post(Community selectedCommunity) {
    if (isTypeImage && bannerFile != null && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
            context: context,
            title: titleController.text,
            image: bannerFile!,
            community: selectedCommunity,
          );
    } else if (isTypeText && titleController.text.isNotEmpty) {
        ref.read(postControllerProvider.notifier).shareTextPost(
            context: context,
            title: titleController.text,
            desc: descriptionController.text.trim(),
            community: selectedCommunity,
          );
    } else if (isTypeLink && titleController.text.isNotEmpty && linkController.text.isNotEmpty) {
        ref.read(postControllerProvider.notifier).shareLinkPost(
            context: context,
            title: titleController.text,
            link: linkController.text.trim(),
            community: selectedCommunity,
          );
    } else {
      showSnackBar(context, "Please enter all the fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCommunity = ref.watch(selectCommunityProvider);
    final isLoading = ref.watch(postControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Post ${widget.type}",  style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),),
        actions: [
          TextButton(
            onPressed: () => post(selectedCommunity ?? _communities[0]),
            child: const Text("Share"),
          ),
        ],
      ),
      body:isLoading? const LoadingWidget(): Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kPading, vertical: kPading / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldWidget(
              controller: titleController,
              hintText: "Enter Title Here",
              maxLength: 30,
            ),
            const SizedBox(
              height: kPading,
            ),
            if (isTypeImage)
              GestureDetector(
                onTap: selectBannerImage,
                child: DottedBorder(
                  radius: const Radius.circular(10),
                  dashPattern: const [10, 4],
                  borderType: BorderType.RRect,
                  strokeCap: StrokeCap.round,
                  color: Theme.of(context).textTheme.bodyText2!.color!,
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
                          : const Center(
                              child: Icon(
                                Icons.camera_alt_rounded,
                                size: 40,
                              ),
                            )),
                ),
              ),
            if (isTypeText)
              TextFieldWidget(
                controller: descriptionController,
                hintText: "Enter Description Here",
                maxLines: 5,
              ),
            if (isTypeLink)
              TextFieldWidget(
                controller: linkController,
                hintText: "Enter Link Here",
                maxLines: 1,
              ),
            const SizedBox(
              height: kPading,
            ),
            ref.watch(userCommunitiesProvider).when(
                data: (communities) {
                  _communities = communities;
                  if (communities.isEmpty) {
                    return const Text("Please join community to make a post");
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Select Community",
                      ),
                      DropdownButton(
                        value: selectedCommunity ?? communities[0],
                        items: communities
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e.name)))
                            .toList(),
                        onChanged: (val) {
                          ref.read(selectCommunityProvider.notifier).state =
                              val;
                        },
                      ),
                    ],
                  );
                },
                error: (err, stackTrace) {
                  return ErrorText(error: err.toString());
                },
                loading: () => const LoadingWidget())
          ],
        ),
      ),
    );
  }
}
