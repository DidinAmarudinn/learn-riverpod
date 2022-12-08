import 'package:flutter/material.dart';
import 'package:journal_riverpod/pagnation/ui/pagination_post_listview.dart';
import 'package:journal_riverpod/pagnation/ui/pagnation_listview.dart';

class SelectExamplePaginationPage extends StatelessWidget {
  const SelectExamplePaginationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaginatedListView()));
              },
              child: const Text(
                "Users Pagnation",
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaginatedPostListView()));
              },
              child: const Text(
                "Posts Pagnation",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
