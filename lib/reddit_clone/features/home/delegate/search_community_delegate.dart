import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_riverpod/reddit_clone/features/community/controller/community_controller.dart';
import 'package:journal_riverpod/reddit_clone/widget/error_text.dart';
import 'package:journal_riverpod/reddit_clone/widget/loading_widget.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;

  SearchCommunityDelegate(this.ref);
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(
          Icons.close,
        ),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunitiesProvider(query)).when(
        data: (communities) {
          return ListView.builder(
            itemCount: communities.length,
            itemBuilder: (context, index) {
              final community = communities[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    community.avatar,
                    height: 45,
                    width: 45,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text("r/${community.name}"),
                onTap: (){
                  Routemaster.of(context).push('/r/${community.name}');
                },
              );
            },
          );
        },
        error: (err, stackTrace) {
          return ErrorText(error: err.toString());
        },
        loading: () => const LoadingWidget());
  }
}
