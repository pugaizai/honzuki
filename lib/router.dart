import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:honzuki/screen/detail/detail_screen.dart';
import 'package:honzuki/screen/error/error_screen.dart';
import 'package:honzuki/screen/home/home_provider.dart';
import 'package:honzuki/screen/palette/palette_screen.dart';
import 'package:honzuki/screen/profile/profile_screen.dart';
import 'package:honzuki/screen/rank/rank_screen.dart';
import 'package:honzuki/screen/reader/reader_screen.dart';
import 'package:honzuki/screen/search/search_screen.dart';
import 'package:honzuki/service/navigation.dart';

import 'http/ajax.dart';
import 'screen/home/home_screen.dart';
import 'screen/login/login_screen.dart';

final router = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      redirect: (context, state) async {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        final cookieJar =
            PersistCookieJar(storage: FileStorage(appDocDir.path));
        final cookies = await cookieJar.loadForRequest(Uri.parse(Ajax.BASEURL));
        if (cookies.isNotEmpty) {
          return "/";
        } else {
          return "/login";
        }
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/reader/:name/:aid/:cIndex',
      builder: (context, state) {
        final name = state.pathParameters["name"] as String;
        final aid = state.pathParameters["aid"] as String;
        final cIndex = int.parse(state.pathParameters["cIndex"] as String);
        return ReaderScreen(name: name, aid: aid, cIndex: cIndex);
      },
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) {
        final searchKey = state.extra as String?;
        return SearchScreen(searchKey: searchKey);
      },
    ),
    GoRoute(
        path: '/detail',
        builder: (context, state) {
          final BookItem bookItem = state.extra as BookItem;
          return DetailScreen(bookItem);
        }),
    GoRoute(
        path: '/profile',
        builder: (context, state) {
          return const ProfileScreen();
        }),
    GoRoute(
        path: '/palette',
        builder: (context, state) {
          return const PaletteScreen();
        }),
    GoRoute(
        path: '/rank/:type/:title',
        builder: (context, state) {
          final type = state.pathParameters["type"] as String;
          return RankScreen(type);
        }),
    GoRoute(
      path: '/error/:err',
      builder: (context, state) {
        final err = state.pathParameters["err"] as String;
        return ErrorScreen(err: err);
      },
    ),
  ],
);
