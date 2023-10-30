import 'dart:async';

import 'package:delivery_app/common/view/root_tab.dart';
import 'package:delivery_app/common/view/splash_screen.dart';
import 'package:delivery_app/restaurant/view/restuarant_detail_screen.dart';
import 'package:delivery_app/user/model/user_model.dart';
import 'package:delivery_app/user/provider/user_me_provider.dart';
import 'package:delivery_app/user/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;
  AuthProvider({required this.ref}) {
    ref.listen<UserModelBase?>(
      userMeProvider,
      (previous, next) {
        if (previous != next) {
          notifyListeners();
        }
      },
    );
  }

  List<GoRoute> get routes => [
        GoRoute(
            path: '/',
            name: RootTab.routeName,
            builder: (_, __) => const RootTab(),
            routes: [
              GoRoute(
                path: 'restaurant/:rid',
                builder: (_, state) =>
                    RestaurantDetailScreen(id: state.pathParameters['rid']!),
              ),
            ]),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (_, __) => const LoginScreen(),
        )
      ];

  FutureOr<String?> redirectLogic(BuildContext context, GoRouterState state) {
    final user = ref.read<UserModelBase?>(userMeProvider);

    final logginIn = state.matchedLocation == '/login';

    if (user == null) {
      return logginIn ? null : '/login';
    }

    if (user is UserModel) {
      return logginIn || state.matchedLocation == '/splash' ? '/' : null;
    }

    if (user is UserModelError) {
      return !logginIn ? '/login' : null;
    }
    return null;
  }
}
