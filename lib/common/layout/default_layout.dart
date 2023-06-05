import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final String? title;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final String? helpContent;

  const DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
    this.helpContent,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppBar(context),
      body: child, //입력받은 child를 그대로
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar(BuildContext context) {
    if (title == null) {
      return null;
    }
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0, //그림자 없애기
      title: Text(
        title!,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      foregroundColor: Colors.black,
      actions: [
        if(helpContent != null)
          IconButton(
            icon: const Icon(Icons.help_outline),
            padding: const EdgeInsets.only(right: 24.0),
            onPressed: () => showHelpDialog(context),
          ),
      ],
    );
  }

  void showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('도움말'),
          content: Text(helpContent!),
          actions: [
            TextButton(
              child: Text('닫기'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
