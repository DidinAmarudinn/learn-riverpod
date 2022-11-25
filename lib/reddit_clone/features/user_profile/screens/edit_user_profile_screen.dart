// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:journal_riverpod/reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:journal_riverpod/reddit_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:journal_riverpod/reddit_clone/utils/image_constants.dart';

import '../../../core/utils.dart';
import '../../../theme/theme.dart';
import '../../../utils/style.dart';
import '../../../widget/error_text.dart';
import '../../../widget/loading_widget.dart';

class EditUserProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditUserProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends ConsumerState<EditUserProfileScreen> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;

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
    nameController =
        TextEditingController(text: ref.read(userProvider)?.name ?? "");
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      profileFile = File(res.files.first.path!);
      setState(() {});
    }
  }

  void save() {
    ref.read(userPforileControllerProvider.notifier).editUserProfile(
        profileFile: profileFile,
        bannerFile: bannerFile,
        name: nameController.text.trim(),
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userPforileControllerProvider);
    return isLoading
        ? const LoadingWidget()
        : ref.watch(getUserDataProvider(widget.uid)).when(data: (user) {
            return Scaffold(
              backgroundColor: ThemeConfig.darkModeAppTheme.backgroundColor,
              appBar: AppBar(
                title: const Text("Edit Profile"),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: () {
                      save();
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
              body: Padding(
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
                              color: ThemeConfig
                                  .darkModeAppTheme.textTheme.bodyText2!.color!,
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
                                    : user.banner.isEmpty ||
                                            user.banner == bannerDefault
                                        ? const Center(
                                            child: Icon(
                                              Icons.camera_alt_rounded,
                                              size: 40,
                                            ),
                                          )
                                        : Image.network(
                                            user.banner,
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
                                          NetworkImage(user.profilePic),
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          filled: true,
                          hintText: "Name",
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(kPading)),
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
