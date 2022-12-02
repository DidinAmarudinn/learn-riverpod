import 'package:flutter/material.dart';
import 'package:journal_riverpod/reddit_clone/features/add_post/screens/add_post_type_screen.dart';
import 'package:journal_riverpod/reddit_clone/features/add_post/screens/comment_screen.dart';
import 'package:journal_riverpod/reddit_clone/features/auth/screens/login_screen.dart';
import 'package:journal_riverpod/reddit_clone/features/community/screens/add_mods_screen.dart';
import 'package:journal_riverpod/reddit_clone/features/community/screens/community_screen.dart';
import 'package:journal_riverpod/reddit_clone/features/community/screens/create_community_screen.dart';
import 'package:journal_riverpod/reddit_clone/features/community/screens/edit_community_screen.dart';
import 'package:journal_riverpod/reddit_clone/features/community/screens/mod_tools_screen.dart';
import 'package:journal_riverpod/reddit_clone/features/home/screens/home_screen.dart';
import 'package:journal_riverpod/reddit_clone/features/user_profile/screens/edit_user_profile_screen.dart';
import 'package:journal_riverpod/reddit_clone/features/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

// Logout Routes
final logoutRoutes =
    RouteMap(routes: {'/': (_) => const MaterialPage(child: LoginScreen())});

// Logined Routes
final loginRoutes = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  CreateCommunityScreen.routeName: (_) =>
      const MaterialPage(child: CreateCommunityScreen()),
  '/r/:name': (route) => MaterialPage(
        child: CommunityScreen(
          name: route.pathParameters["name"] ?? "",
        ),
      ),
  '/mod-tools/:name': (routeData) => MaterialPage(
        child: ModToolsScreen(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/edit-community/:name': (routeData) => MaterialPage(
        child: EditCommunityScreen(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/add-mods/:name': (routeData) => MaterialPage(
        child: AddModsScreen(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/u/:uid': (route) => MaterialPage(
        child: UserProfileScreen(
          uid: route.pathParameters["uid"] ?? "",
        ),
      ),
  '/edit-user-profile/:uid': (route) => MaterialPage(
        child: EditUserProfileScreen(
          uid: route.pathParameters["uid"] ?? "",
        ),
      ),
  '/add-post/:type': (route) => MaterialPage(
        child: AddPostTypeScreen(
          type: route.pathParameters["type"] ?? "",
        ),
      ),
  '/post/:postId/comments': (route) => MaterialPage(
        child: CommentScreen(
          postId: route.pathParameters["postId"] ?? "",
        ),
      ),
});
