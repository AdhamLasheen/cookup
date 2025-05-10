import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      color: const Color.fromRGBO(0, 0, 0, 0.122),
      child: Theme(
        data: ThemeData.dark(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 250,
              height: 500,
              child: Container(
                color: Colors.black87,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Menu', style:GoogleFonts
                          .fascinateInline()
                          .copyWith(color: Colors.white, fontSize: 35)),
                    ),
        
                    const Divider(
                      thickness: 2,
                    ),
        
                    ListTile(
                      title: Text('Home'),
                      leading: const Icon(Icons.home),
                      subtitle: Text('Where you sleep'),
                    )
                    
                  ],
                ),
              ),
            ),
            Expanded(child: Container(child: Center(child: Text('Hellow')))),
          ],
        ),
      ),
    );
  }
}
