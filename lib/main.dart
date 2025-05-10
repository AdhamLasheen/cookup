import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const Home());
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        children: [
          SizedBox(width: 250, child: Container(color:  Colors.black87)),
          Expanded(
            child: Container(
              color: Colors.black12,
              child: Center(child: Text('Hellow')),
            ),
          ),
        ],
      ),
    );
  }
}
