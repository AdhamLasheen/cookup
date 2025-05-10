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
                decoration: BoxDecoration(
                color: Colors.black87,
                 borderRadius: 
                 BorderRadius.circular(8),
                 ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Menu', style:GoogleFonts
                          .lora()
                          .copyWith(color: Colors.white, fontSize: 35)),
                    ),
        
                    const Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
        
                    ListTile(
                      title: Text('resipes'),
                      leading: const Icon(Icons.menu_book_outlined),
                    ),
                    ListTile(
                      title: Text('ingredients'),
                      leading: const Icon(Icons.egg),
                      
                    ),ListTile(
                      title: Text('saved recipes'),
                      leading: const Icon(Icons.offline_pin)
                    ),
                    ListTile(
                      title: Text('help'),
                      leading: const Icon(Icons.help),)
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
