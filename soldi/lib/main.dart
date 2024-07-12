import 'package:flutter/material.dart';
import 'package:soldi/pages/watch_page.dart';

void main() {
  runApp(const Soldi());
}

class Soldi extends StatelessWidget {
  const Soldi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Soldi",
      theme: ThemeData.light(),
      home: WatchPage(),
    );
  }
}