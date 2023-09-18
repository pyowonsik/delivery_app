import 'package:delivery_app/common/component/custom_text_form_filed.dart';
import 'package:delivery_app/common/view/splash_screen.dart';
import 'package:delivery_app/user/view/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: const SplashScreen(),
    );
  }
}
