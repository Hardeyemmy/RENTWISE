import 'package:flutter/material.dart';
import '../widgets/hero_welcome.dart';
import '../widgets/stat_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [HeroSection(), StatSection()]),
      ),
    );
  }
}
