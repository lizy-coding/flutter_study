import 'package:flutter/material.dart';

import 'web_unavailable_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => const WebUnavailablePage();
}
