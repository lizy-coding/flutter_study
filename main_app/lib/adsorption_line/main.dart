import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/drawing_state.dart';
import 'widgets/drawing_board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DrawingState(),
      child: MaterialApp(
        title: '吸附线画板',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const DrawingBoard(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
