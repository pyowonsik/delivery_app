import 'package:flutter/material.dart';

// 모든 스크린에 공통적인 작업이 필요한 경우
class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;

  const DefaultLayout(
      {super.key,
      this.title,
      this.backgroundColor,
      required this.child,
      this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppBar(),
      body: TabBarView(children: [
        Container(
          child: Text('홈'),
        ),
        Container(
          child: Text('음식'),
        ),
        Container(
          child: Text('주문'),
        ),
        Container(
          child: Text('프로필 '),
        ),
      ]),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title!,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.black,
      );
    }
  }
}
