import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/core/utils.dart';
import 'package:journal_riverpod/reddit_clone/features/community/controller/community_controller.dart';
import 'package:journal_riverpod/reddit_clone/utils/style.dart';
import 'package:journal_riverpod/reddit_clone/widget/loading_widget.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  static const routeName = "/create-community-screen";
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    communityNameController.dispose();
    super.dispose();
  }

  void createCommuntiy() {
    ref.read(communityControllerProvider.notifier).createCommunity(
          communityNameController.text.trim(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Create Community",
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
      ),
      body: loading
          ? const LoadingWidget()
          : Padding(
              padding: const EdgeInsets.all(kPading),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Community name"),
                  const SizedBox(
                    height: kPading / 2,
                  ),
                  TextField(
                    controller: communityNameController,
                    decoration: const InputDecoration(
                      hintText: "r/Community_name",
                      filled: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(kPading / 2),
                    ),
                    maxLength: 21,
                  ),
                  const SizedBox(
                    height: kPading,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (communityNameController.text.isNotEmpty) {
                        createCommuntiy();
                      } else {
                        showSnackBar(context, "Please fill community name");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          25,
                        ),
                      ),
                    ),
                    child: const Text(
                      "Create Community",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
