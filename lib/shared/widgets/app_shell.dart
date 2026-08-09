import 'package:flutter/material.dart';
import 'responsive_nav.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ResponsiveNav(child: child));
  }
}
