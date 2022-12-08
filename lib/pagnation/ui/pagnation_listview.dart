import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/pagnation/model/list_user_dummy_model.dart';
import 'package:journal_riverpod/pagnation/riverpod/pagnation_notifier.dart';


class PaginatedListView extends ConsumerWidget {
  PaginatedListView({Key? key}) : super(key: key);

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.width * 0.20;
      if (maxScroll - currentScroll <= delta) {
        ref.read(itemsFakeUserProvider.notifier).fetchNextBatch();
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
          const SliverAppBar(
            centerTitle: true,
            pinned: true,
            title: Text('Infinite Pagination'),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
          UserItemsList(
            stateNotifierProvider: itemsFakeUserProvider,
            onTap: () {
              ref.read(itemsFakeUserProvider.notifier).fetchFirstBatch();
            },
          ),
          NoMoreItems(
            stateNotifierProvider: itemsFakeUserProvider,
            callback: () =>
                ref.read(itemsFakeUserProvider.notifier).noMoreItems,
          ),
          OnGoingBottomWidget(
            stateNotifierProvider: itemsFakeUserProvider,
          ),
        ],
      ),
    );
  }
}

class ScrollToTopButton extends StatelessWidget {
  const ScrollToTopButton({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        double scrollOffset = scrollController.offset;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: scrollOffset > MediaQuery.of(context).size.height * 0.5
              ? FloatingActionButton(
                  tooltip: "Scroll to top",
                  child: const Icon(
                    Icons.arrow_upward,
                  ),
                  onPressed: () async {
                    scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}

class NoMoreItems extends ConsumerWidget {
  final StateNotifierProvider stateNotifierProvider;
  final bool Function() callback;
  const NoMoreItems({
    Key? key,
    required this.stateNotifierProvider,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stateNotifierProvider);

    return SliverToBoxAdapter(
      child: state.maybeWhen(
        orElse: () => const SizedBox.shrink(),
        data: (items) {
          bool noMoreItems = callback();
          return noMoreItems
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "No More Items Found!",
                    textAlign: TextAlign.center,
                  ),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}

class UserItemsList extends StatelessWidget {
  final StateNotifierProvider stateNotifierProvider;
  final VoidCallback onTap;
  const UserItemsList(
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

  final List<UserData> items;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var user = items[index];
          return ListTile(
            title: Text("${user.firstName ?? ""} ${index + 1}"),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.picture ?? ""),
              radius: 30,
            ),
            subtitle: Text(user.firstName ?? ""),
          );
        },
        childCount: items.length,
      ),
    );
  }
}

class OnGoingBottomWidget extends StatelessWidget {
  final StateNotifierProvider stateNotifierProvider;
  const OnGoingBottomWidget({Key? key, required this.stateNotifierProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(40),
      sliver: SliverToBoxAdapter(
        child: Consumer(builder: (context, ref, child) {
          final state = ref.watch(stateNotifierProvider);
          return state.maybeWhen(
            orElse: () => const SizedBox.shrink(),
            onGoingLoading: (items) =>
                const Center(child: CircularProgressIndicator()),
            onGoingError: (items, e) => Center(
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
          );
        }),
      ),
    );
  }
}
