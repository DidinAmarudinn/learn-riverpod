import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/pagnation/model/list_post_fake_model.dart';
import 'package:journal_riverpod/pagnation/riverpod/pagnation_notifier.dart';
import 'package:journal_riverpod/pagnation/ui/pagnation_listview.dart';
import 'package:journal_riverpod/reddit_clone/utils/style.dart';

class PaginatedPostListView extends ConsumerWidget {
  PaginatedPostListView({Key? key}) : super(key: key);

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.width * 0.20;
      if (maxScroll - currentScroll <= delta) {
        ref.read(itemsPostsProvider.notifier).fetchNextBatch();
      }
    });
    return Scaffold(
      floatingActionButton: ScrollToTopButton(
        scrollController: scrollController,
      ),
      body: CustomScrollView(
        controller: scrollController,
        restorationId: "items List",
        slivers: [
          SliverAppBar(
            centerTitle: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.navigate_before,
                color: Colors.black,
                size: 30,
              ),
            ),
            title: const Text(
              'Posts',
              style: TextStyle(color: Colors.black),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
          PostItemsList(
              stateNotifierProvider: itemsPostsProvider,
              onTap: () {
                ref.read(itemsPostsProvider.notifier).fetchFirstBatch();
              }),
          NoMoreItems(
            stateNotifierProvider: itemsPostsProvider,
            callback: () => ref.read(itemsPostsProvider.notifier).noMoreItems,
          ),
          OnGoingBottomWidget(
            stateNotifierProvider: itemsPostsProvider,
          ),
        ],
      ),
    );
  }
}

class PostItemsList extends StatelessWidget {
  final StateNotifierProvider stateNotifierProvider;
  final VoidCallback onTap;
  const PostItemsList(
      {Key? key, required this.stateNotifierProvider, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(stateNotifierProvider);
      return state.when(
        data: (items) {
          return items.isEmpty
              ? SliverToBoxAdapter(
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: onTap,
                        icon: const Icon(Icons.replay),
                      ),
                      const Chip(
                        label: Text("No items Found!"),
                      ),
                    ],
                  ),
                )
              : ItemsListBuilder(
                  items: items,
                );
        },
        loading: () => const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator())),
        error: (e) => SliverToBoxAdapter(
          child: Center(
            child: Column(
              children: [
                const Icon(Icons.info),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  e,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        onGoingLoading: (items) {
          return ItemsListBuilder(
            items: items,
          );
        },
        onGoingError: (items, e) {
          return ItemsListBuilder(
            items: items,
          );
        },
      );
    });
  }
}

class ItemsListBuilder extends StatelessWidget {
  const ItemsListBuilder({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<PostData> items;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var post = items[index];
          return Container(
            margin: const EdgeInsets.symmetric(
                horizontal: kPading/2, vertical: kPading / 3),
            padding: const EdgeInsets.all(kPading / 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 2,
                    blurRadius: 20,
                    offset: const Offset(0, 1)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        post.owner?.picture ?? "",
                      ),
                      radius: 20,
                    ),
                    const SizedBox(
                      width: kPading / 2,
                    ),
                    Text(post.owner?.getFullOwnerName() ?? ""),
                  ],
                ),
                const SizedBox(height: kPading/2,),
                Text(post.text ?? "", style: const TextStyle(color: Colors.grey),),
                const SizedBox(
                  height: kPading,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(post.image ?? ""))
              ],
            ),
          );
        },
        childCount: items.length,
      ),
    );
  }
}
