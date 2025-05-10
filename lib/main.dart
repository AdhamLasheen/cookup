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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedTab = 0;
  final List<String> selectedIngredients = []; // List to store clicked ingredients

  void switchToRecipes() {
    setState(() {
      selectedTab = 0;
    });
  }

  void switchToIngredients() {
    setState(() {
      selectedTab = 1;
    });
  }

  void switchToSavedRecipes() {
    setState(() {
      selectedTab = 2;
    });
  }

  void switchToHelp() {
    setState(() {
      selectedTab = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allIngredients = [
      'Eggs',
      'Potatoes',
      'Steak',
      'Cheese',
      'Butter or\nOil', // Grouped Butter and Oil
      'Salt',
      'Pepper',
      'Chicken',
      'Bread',
      'Garlic',
      'Onion',
      'Parsley',
      'Paprika',
      'Chili Powder',
      'Vinegar'
    ]; // Full list of ingredients

    final availableIngredients = allIngredients
        .where((ingredient) => !selectedIngredients.contains(ingredient))
        .toList(); // Filter out selected ingredients

    return Material(
      color: const Color.fromRGBO(0, 0, 0, 0.122),
      child: Theme(
        data: ThemeData.dark(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 250,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Menu',
                                style: GoogleFonts.lora()
                                    .copyWith(color: Colors.white, fontSize: 35)),
                          ),
                          const Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                          ListTile(
                            title: Text('resipes'),
                            leading: const Icon(Icons.menu_book_outlined),
                            onTap: switchToRecipes,
                          ),
                          ListTile(
                            title: Text('ingredients'),
                            leading: const Icon(Icons.egg),
                            onTap: switchToIngredients,
                          ),
                          ListTile(
                            title: Text('saved recipes'),
                            leading: const Icon(Icons.offline_pin),
                            onTap: switchToSavedRecipes,
                          ),
                          ListTile(
                            title: Text('help'),
                            leading: const Icon(Icons.help),
                            onTap: switchToHelp,
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Adham Lasheen',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: selectedTab == 0
                      ? GridView.count(
                          crossAxisCount: 3,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          padding: const EdgeInsets.all(20),
                          children: List.generate(6, (index) {
                            final labels = [
                              'Eggs',
                              'Mashed Potatoes',
                              'Steak',
                              'Grilled Cheese',
                              'Boiled Eggs',
                              'Chicken'
                            ];
                            return Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Center(
                                    child: Icon(
                                      Icons.menu_book,
                                      color: Colors.grey[700],
                                      size: 50,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  left: 0,
                                  right: 0,
                                  child: Text(
                                    labels[index],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 4,
                                          color: Colors.grey,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            );
                          }),
                        )
                      : selectedTab == 1
                          ? Column(
                              children: [
                                Container(
                                  height: 100,
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: Center(
                                    child: Text(
                                      selectedIngredients.isEmpty
                                          ? 'Selected Ingredients'
                                          : selectedIngredients.join(', '),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 50,
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[400]!, width: 1),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'White Box',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: GridView.count(
                                    crossAxisCount: 4, // Adjusted for larger boxes
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    padding: const EdgeInsets.all(20),
                                    children: List.generate(availableIngredients.length, (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (!selectedIngredients.contains(availableIngredients[index])) {
                                              selectedIngredients.add(availableIngredients[index]);
                                            }
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              availableIngredients[index],
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            )
                      : selectedTab == 2
                          ? const Center(
                              child: Text(
                                'Saved Recipes Room',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                      : const Center(
                              child: Text(
                                'Help Room',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
