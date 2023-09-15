import 'package:flutter/material.dart';

// 모든 스크린에 공통적인 작업이 필요한 경우
class DefaultLayout extends StatelessWidget {
  final Widget child;

  const DefaultLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: child,
    );
  }
}
