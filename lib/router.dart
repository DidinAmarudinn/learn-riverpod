import 'package:flutter/material.dart';
import 'package:journal_riverpod/reddit_clone/features/auth/screens/login_screen.dart';
import 'package:journal_riverpod/reddit_clone/features/community/screens/community_screen.dart';
import 'package:journal_riverpod/reddit_clone/features/home/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

// Logout Routes
final logoutRoutes =
    RouteMap(routes: {'/': (_) => const MaterialPage(child: LoginScreen())});

// Logined Routes
final loginRoutes = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  CreateCommunityScreen.routeName : (_) => const MaterialPage(child: CreateCommunityScreen())
});
