import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math' as math; // Add this import at the top with other imports

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
  String selectedMealType = ''; // To store the selected meal type (breakfast, lunch, dinner, or dessert)
  final List<String> selectedIngredients = []; // List to store clicked ingredients
  final List<String> savedRecipes = []; // List to store saved recipes
  String searchQuery = ''; // Store the search query
  bool isSpinning = false; // Track if the roulette is spinning
  Map<String, Timer> activeTimers = {}; // Add this for storing multiple timers
  Map<String, int> timerDurations = {}; // Store remaining time for each timer
  bool isDarkMode = false; // Track dark mode setting
  double fontSize = 16.0; // Track font size setting
  String selectedLanguage = 'English';

  final Map<String, Map<String, String>> translations = {
    'English': {
      'menu': 'Menu',
      'recipes': 'Recipes',
      'ingredients': 'Ingredients',
      'saved_recipes': 'Saved Recipes',
      'recipe_roulette': 'Recipe Roulette',
      'recipe_timers': 'Recipe Timers',
      'settings': 'Settings',
      'help': 'Help',
      'search_for_recipes': 'Search for Recipes',
    },
    'Arabic': {
      'menu': 'القائمة',
      'recipes': 'وصفات',
      'ingredients': 'مكونات',
      'saved_recipes': 'الوصفات المحفوظة',
      'recipe_roulette': 'عجلة الوصفات',
      'recipe_timers': 'مؤقتات',
      'settings': 'إعدادات',
      'help': 'مساعدة',
      'search_for_recipes': 'البحث عن الوصفات',
    },
    'French': {
      'menu': 'Menu',
      'recipes': 'Recettes',
      'ingredients': 'Ingrédients',
      'saved_recipes': 'Recettes Sauvegardées',
      'recipe_roulette': 'Roulette de Recettes',
      'recipe_timers': 'Minuteries',
      'settings': 'Paramètres',
      'help': 'Aide',
      'search_for_recipes': 'Rechercher des Recettes',
    },
    'Spanish': {
      'menu': 'Menú',
      'recipes': 'Recetas',
      'ingredients': 'Ingredientes',
      'saved_recipes': 'Recetas Guardadas',
      'recipe_roulette': 'Ruleta de Recetas',
      'recipe_timers': 'Temporizadores',
      'settings': 'Ajustes',
      'help': 'Ayuda',
      'search_for_recipes': 'Buscar Recetas',
    }
  };

  String getTranslatedText(String key) {
    return translations[selectedLanguage]?[key] ?? translations['English']![key]!;
  }

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

  void switchToFilteredRecipes() {
    if (selectedIngredients.isNotEmpty) {
      setState(() {
        selectedTab = 5;
      });
    }
  }

  void switchToRecipeRoulette() {
    setState(() {
      selectedTab = 6; // New tab for Recipe Roulette
      selectedRecipe = ''; // Reset the recipe when entering the tab
    });
  }

  void switchToTimers() {
    setState(() {
      selectedTab = 8; // New tab for timers
    });
  }

  void switchToSettings() {
    setState(() {
      selectedTab = 9; // New tab for settings
    });
  }

  void startRoulette() async {
    setState(() {
      isSpinning = true;
    });

    final random = math.Random();
    final recipes = recipeDetails.keys.toList()..shuffle(random);
    
    // Show more random recipes while spinning
    for (int i = 0; i < 20; i++) {
      await Future.delayed(Duration(milliseconds: 100 + (i * 10)), () {
        setState(() {
          selectedRecipe = recipes[random.nextInt(recipes.length)];
        });
      });
    }

    // Final selection
    await Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        selectedRecipe = recipes[random.nextInt(recipes.length)];
        isSpinning = false;
      });
    });
  }

  void startTimer(String name, int totalSeconds) {
    if (activeTimers.containsKey(name)) {
      activeTimers[name]?.cancel();
    }
    
    timerDurations[name] = totalSeconds;
    activeTimers[name] = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timerDurations[name]! > 0) {
          timerDurations[name] = timerDurations[name]! - 1;
        } else {
          timer.cancel();
          activeTimers.remove(name);
        }
      });
    });
  }

  @override
  void dispose() {
    for (final timer in activeTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }

  // Helper method to build meal type filter buttons
  Widget buildMealTypeFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilterChip(
          label: const Text('Breakfast'),
          selected: selectedMealType == 'breakfast',
          onSelected: (selected) {
            setState(() {
              selectedMealType = selected ? 'breakfast' : '';
            });
          },
          backgroundColor: Colors.white,
          selectedColor: Colors.black,
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: selectedMealType == 'breakfast' ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(width: 10),
        FilterChip(
          label: const Text('Lunch'),
          selected: selectedMealType == 'lunch',
          onSelected: (selected) {
            setState(() {
              selectedMealType = selected ? 'lunch' : '';
            });
          },
          backgroundColor: Colors.white,
          selectedColor: Colors.black,
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: selectedMealType == 'lunch' ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(width: 10),
        FilterChip(
          label: const Text('Dinner'),
          selected: selectedMealType == 'dinner',
          onSelected: (selected) {
            setState(() {
              selectedMealType = selected ? 'dinner' : '';
            });
          },
          backgroundColor: Colors.white,
          selectedColor: Colors.black,
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: selectedMealType == 'dinner' ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(width: 10),
        FilterChip(
          label: const Text('Dessert'),
          selected: selectedMealType == 'dessert',
          onSelected: (selected) {
            setState(() {
              selectedMealType = selected ? 'dessert' : '';
            });
          },
          backgroundColor: Colors.white,
          selectedColor: Colors.black,
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: selectedMealType == 'dessert' ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  List<String> getFilteredRecipes() {
    if (selectedIngredients.isEmpty) {
      return [];
    }

    return recipeDetails.keys.where((recipe) {
      String ingredients = recipeDetails[recipe]?['ingredients']?.toLowerCase() ?? '';
      
      // Convert ingredients to a list
      List<String> recipeIngredients = ingredients
          .split('\n')
          .map((line) => line.trim().replaceAll(RegExp(r'^-\s*'), ''))
          .where((line) => line.isNotEmpty)
          .toList();

      // Check if recipe contains any of the selected ingredients
      return selectedIngredients.any((selected) {
        return recipeIngredients.any((ingredient) =>
            ingredient.toLowerCase().contains(selected.toLowerCase()));
      });
    }).toList();
  }

  String selectedRecipe = ''; // Store the selected recipe name
  int previousTab = 0; // Add this to track where we came from

  void switchToRecipeDetails(String recipeName) {
    setState(() {
      previousTab = selectedTab; // Store current tab before switching
      selectedTab = 4; // New tab for recipe details
      selectedRecipe = recipeName; // Store the selected recipe name
    });
  }

  Map<String, Map<String, dynamic>> recipeDetails = {
    'Eggs': {
      'ingredients': '- 2 Eggs\n- Salt\n- Pepper\n- Butter',
      'mealType': 'breakfast',
      'instructions': '1. Heat a pan over medium heat.\n'
          '2. Add butter to the pan.\n'
          '3. Crack the eggs into the pan.\n'
          '4. Sprinkle salt and pepper.\n'
          '5. Cook until desired doneness.',
    },
    'Mashed Potatoes': {
      'ingredients': '- 4 Potatoes\n- Butter\n- Milk\n- Salt\n- Pepper',
      'mealType': 'dinner',
      'instructions':'1. Peel and boil the potatoes until soft.\n'
          '2. Mash the potatoes.\n'
          '3. Add butter, milk, salt, and pepper.\n'
          '4. Mix until smooth.',
    },
    'Steak': {
      'ingredients': '- 1 Steak\n- Salt\n- Pepper\n- Olive Oil',
      'mealType': 'dinner',
      'instructions':'1. Season the steak with salt and pepper.\n'
          '2. Heat olive oil in a pan over high heat.\n'
          '3. Cook the steak to your desired doneness.\n'
          '4. Let it rest before serving.',
    },
    'Grilled Cheese': {
      'ingredients': '- 2 Slices of Bread\n- Butter\n- 2 Slices of Cheese',
      'mealType': 'lunch',
      'instructions':'1. Butter one side of each slice of bread.\n'
          '2. Place cheese between the unbuttered sides.\n'
          '3. Grill in a pan until golden brown on both sides.',
    },
    'Boiled Eggs': {
      'ingredients': '- 2 Eggs\n- Water\n- Salt',
      'mealType': 'breakfast',
      'instructions':'1. Place eggs in a pot and cover with water.\n'
          '2. Bring to a boil and cook for 6-10 minutes.\n'
          '3. Cool in ice water before peeling.',
    },
    'Chicken': {
      'ingredients': '- 1 Chicken Breast\n- Salt\n- Pepper\n- Olive Oil',
      'mealType': 'dinner',
      'instructions':'1. Season the chicken with salt and pepper.\n'
          '2. Heat olive oil in a pan over medium heat.\n'
          '3. Cook the chicken until fully cooked.\n'
          '4. Let it rest before serving.',
    },
    'Pancakes': {
      'ingredients': '- 1 Cup Flour\n- 1 Cup Milk\n- 1 Egg\n- 2 Tbsp Sugar\n- 1 Tsp Baking Powder\n- Butter',
      'mealType': 'breakfast',
      'instructions':'1. Mix flour, sugar, and baking powder in a bowl.\n'
          '2. Add milk and egg, and whisk until smooth.\n'
          '3. Heat a pan and add butter.\n'
          '4. Pour batter into the pan and cook until bubbles form.\n'
          '5. Flip and cook until golden brown.',
    },
    'Brownies': {
      'ingredients': '- 1/2 Cup Butter\n- 1 Cup Sugar\n- 2 Eggs\n- 1/3 Cup Cocoa Powder\n- 1/2 Cup Flour\n- 1 Tsp Vanilla Extract',
      'mealType': 'dessert',
      'instructions': '1. Melt butter and mix with sugar.\n'
          '2. Add eggs and vanilla extract, and whisk.\n'
          '3. Stir in cocoa powder and flour.\n'
          '4. Pour batter into a greased pan.\n'
          '5. Bake at 350°F (175°C) for 20-25 minutes.',
    },
    'Apple Pie': {
      'ingredients': '- 2 Apples\n- 1/2 Cup Sugar\n- 1 Tsp Cinnamon\n- 1 Pie Crust\n- Butter',
      'mealType': 'dessert',
      'instructions': '1. Slice apples and mix with sugar and cinnamon.\n'
          '2. Place the mixture in a pie crust.\n'
          '3. Dot with butter and cover with another crust.\n'
          '4. Bake at 375°F (190°C) for 40 minutes.\n'
          '5. Serve warm.',
    },
    'Chocolate Chip Cookies': {
      'ingredients': '- 1/2 Cup Butter\n- 1/2 Cup Sugar\n- 1/2 Cup Brown Sugar\n- 1 Egg\n- 1 Tsp Vanilla Extract\n- 1 1/4 Cups Flour\n- 1/2 Tsp Baking Soda\n- 1 Cup Chocolate Chips',
      'mealType': 'dessert',
      'instructions': '1. Cream butter, sugar, and brown sugar together.\n'
          '2. Add egg and vanilla extract, and mix well.\n'
          '3. Stir in flour and baking soda.\n'
          '4. Fold in chocolate chips.\n'
          '5. Drop spoonfuls onto a baking sheet and bake at 350°F (175°C) for 10-12 minutes.',
    },
    // Add other recipes with mealType here...
  };

  @override
  Widget build(BuildContext context) {
    // Add these color variables at the start of build method
    final backgroundColor = isDarkMode ? Colors.black : const Color.fromRGBO(0, 0, 0, 0.122);
    final cardColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final borderColor = isDarkMode ? Colors.grey[600] : Colors.grey[400];

    final allIngredients = [
      'Eggs',
      'Potatoes',
      'Steak',
      'Cheese',
      'Butter', // Separated Butter
      'Oil',    // Separated Oil
      'Salt',
      'Pepper',
      'Chicken',
      'Bread',
      'Garlic',
      'Onion',
      'Parsley',
      'Paprika',
      'Chili Powder',
      'Vinegar',
      'Milk',
      'Sugar',
      'Baking Powder',
      'Flour',
      'Tomato Sauce',
      'Parmesan Cheese',
      'Romaine Lettuce',
      'Croutons',
      'Caesar Dressing',
      'Vanilla Extract',
      'Cocoa Powder',
      'Spaghetti',
      'Butter',
      'Water',
      'Grilled Chicken',
      'Olive Oil',
      'Garlic Cloves',
      // Added ingredients from new recipes
      'Tomatoes',
      'Vegetable Broth',
      'Baguette',
      'Mushrooms',
      'Sour Cream',
      'White Wine',
      'Lemon Juice',
      'Cauliflower',
      'Coconut Milk',
      'Curry Powder',
      'Apples',
      'Cinnamon',
      'Rice',
      'Mixed Vegetables',
      'Celery',
      'Fish Fillets',
      'Cabbage',
      'Taco Shells',
      'Mozzarella Cheese',
      'Basil Leaves',
      'Balsamic Glaze',
      'Basil Pesto',
      'Blueberries',
      'Kidney Beans',
      'Feta Cheese',
      'Olives',
      'Pumpkin Puree',
      'Nutmeg',
      'Tortillas',
      'Yogurt',
      'Granola',
      'Honey',
      'Garam Masala',
      'Bell Peppers'
    ]; // Full list of ingredients

    final availableIngredients = allIngredients
        .where((ingredient) => !selectedIngredients.contains(ingredient))
        .toList(); // Filter out selected ingredients

    return Material(
      color: backgroundColor,
      child: Theme(
        data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
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
                        color: isDarkMode ? Colors.grey[900] : Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(getTranslatedText('menu'),
                                style: GoogleFonts.lora()
                                    .copyWith(color: Colors.white, fontSize: 35)),
                          ),
                          const Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                          ListTile(
                            title: Text(getTranslatedText('recipes'), style: const TextStyle(color: Colors.white)),
                            leading: const Icon(Icons.menu_book_outlined, color: Colors.white),
                            onTap: switchToRecipes,
                          ),
                          ListTile(
                            title: Text(getTranslatedText('ingredients'), style: const TextStyle(color: Colors.white)),
                            leading: const Icon(Icons.egg, color: Colors.white),
                            onTap: switchToIngredients,
                          ),
                          ListTile(
                            title: Text(getTranslatedText('saved_recipes'), style: const TextStyle(color: Colors.white)),
                            leading: const Icon(Icons.offline_pin, color: Colors.white),
                            onTap: switchToSavedRecipes,
                          ),
                          ListTile(
                            title: Text(getTranslatedText('recipe_roulette'), style: const TextStyle(color: Colors.white)),
                            leading: const Icon(Icons.casino, color: Colors.white),
                            onTap: switchToRecipeRoulette,
                          ),
                          ListTile(
                            title: Text(getTranslatedText('recipe_timers'), style: const TextStyle(color: Colors.white)),
                            leading: const Icon(Icons.timer, color: Colors.white),
                            onTap: switchToTimers,
                          ),
                          ListTile(
                            title: Text(getTranslatedText('help'), style: const TextStyle(color: Colors.white)),
                            leading: const Icon(Icons.help, color: Colors.white),
                            onTap: switchToHelp,
                          ),
                          ListTile(
                            title: Text(getTranslatedText('settings'), style: const TextStyle(color: Colors.white)),
                            leading: const Icon(Icons.settings, color: Colors.white),
                            onTap: switchToSettings,
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Adham Lasheen',
                              style: TextStyle(
                                color: textColor,
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
              child: Stack(
                children: [
                  if (selectedTab == 3) // Show detailed description only for the Help tab
                    Positioned(
                      top: 10,
                      left: 40, // Adjusted to make it touch the black box
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'What Each Room Does',
                                style: TextStyle(
                                  color: textColor, // Text color set to dynamic
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Ingredient Room\n'
                                'Select the ingredients you currently have. You can search for items, add them to your list, and remove them anytime.\n',
                                style: TextStyle(
                                  color: textColor, // Text color set to dynamic
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Recipe Room\n'
                                'Get recipe suggestions based on the ingredients you\'ve selected. The more you add, the more personalized the results.\n',
                                style: TextStyle(
                                  color: textColor, // Text color set to dynamic
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Saved Recipe Room\n'
                                'Save your favorite recipes so you can find them easily later.\n',
                                style: TextStyle(
                                  color: textColor, // Text color set to dynamic
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Help Room (You\'re here)\n'
                                'Use this space to get guidance, ask questions, or report any issues you’re having with the app.',
                                style: TextStyle(
                                  color: textColor, // Text color set to dynamic
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Container(
                    child: Center(
                      child: selectedTab == 0
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        searchQuery = value.toLowerCase(); // Update search query
                                      });
                                    },
                                    style: TextStyle(color: textColor), // Set text color dynamically
                                    decoration: InputDecoration(
                                      hintText: 'Search recipes...',
                                      hintStyle: TextStyle(color: borderColor), // Hint text color dynamically
                                      prefixIcon: Icon(Icons.search, color: borderColor),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: cardColor,
                                    ),
                                  ),
                                ),
                                buildMealTypeFilters(), // Add meal type filters
                                Expanded(
                                  child: GridView.count(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 20,
                                    padding: const EdgeInsets.all(20),
                                    children: recipeDetails.keys
                                        .where((recipe) {
                                          final mealType = recipeDetails[recipe]?['mealType']?.toLowerCase() ?? '';
                                          final matchesSearch = recipe.toLowerCase().contains(searchQuery);
                                          final matchesMealType = selectedMealType.isEmpty || mealType == selectedMealType;
                                          return matchesSearch && matchesMealType;
                                        })
                                        .map((recipe) {
                                      return GestureDetector(
                                        onTap: () {
                                          switchToRecipeDetails(recipe);
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: cardColor,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            Positioned.fill(
                                              child: Center(
                                                child: Icon(
                                                  Icons.menu_book,
                                                  color: isDarkMode ? Colors.white : Colors.grey[700],
                                                  size: 50,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 8,
                                              left: 0,
                                              right: 0,
                                              child: Text(
                                                recipe,
                                                style: TextStyle(
                                                  color: textColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    Shadow(
                                                      blurRadius: 4,
                                                      color: borderColor!,
                                                      offset: Offset(2, 2),
                                                    ),
                                                  ],
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            )
                          : selectedTab == 4
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.arrow_back, color: textColor),
                                          onPressed: () {
                                            setState(() {
                                              selectedTab = previousTab; // Go back to previous tab
                                            });
                                          },
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Recipe Details',
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            savedRecipes.contains(selectedRecipe) 
                                                ? Icons.favorite 
                                                : Icons.favorite_border,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (savedRecipes.contains(selectedRecipe)) {
                                                savedRecipes.remove(selectedRecipe);
                                              } else {
                                                savedRecipes.add(selectedRecipe);
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.all(16.0),
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          color: cardColor,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Recipe: $selectedRecipe',
                                              style: TextStyle(
                                                color: textColor,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Ingredients:\n${recipeDetails[selectedRecipe]?['ingredients'] ?? ''}',
                                              style: TextStyle(
                                                color: textColor,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Instructions:\n${recipeDetails[selectedRecipe]?['instructions'] ?? ''}',
                                              style: TextStyle(
                                                color: textColor,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : selectedTab == 1
                                  ? Column(
                                      children: [
                                        Container(
                                          constraints: BoxConstraints(
                                            minHeight: 100,
                                            maxHeight: 100 + (selectedIngredients.length > 4 ? 50 : 0) + (selectedIngredients.length > 8 ? 50 : 0),
                                          ), // Adjust height dynamically for each row
                                          margin: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: cardColor,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: borderColor!, width: 2),
                                          ),
                                          child: Center(
                                            child: Wrap(
                                              spacing: 8.0,
                                              runSpacing: 8.0,
                                              children: selectedIngredients.map((ingredient) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedIngredients.remove(ingredient);
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: cardColor,
                                                      borderRadius: BorderRadius.circular(8),
                                                      border: Border.all(
                                                        color: borderColor!,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      ingredient,
                                                      style: TextStyle(
                                                        color: textColor,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        GestureDetector(
                                          onTap: selectedIngredients.isEmpty
                                              ? null
                                              : switchToFilteredRecipes,
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 10),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: selectedIngredients.isEmpty
                                                  ? Colors.grey[300]
                                                  : Colors.blue[100],
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: selectedIngredients.isEmpty
                                                    ? Colors.grey
                                                    : Colors.blue,
                                                width: 2,
                                              ),
                                            ),
                                            child: Text(
                                              getTranslatedText('search_for_recipes'),
                                              style: TextStyle(
                                                color: textColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Expanded(
                                          child: GridView.count(
                                            crossAxisCount: 4, // Adjusted for larger boxes
                                            mainAxisSpacing: 10,
                                            crossAxisSpacing: 10,
                                            padding: const EdgeInsets.all(20),
                                            children: allIngredients
                                                .where((ingredient) {
                                                  // Filter ingredients based on selected meal type
                                                  if (selectedMealType.isEmpty) return true;
                                                  return recipeDetails.values.any((recipe) =>
                                                      recipe['mealType'] == selectedMealType &&
                                                      recipe['ingredients'].toLowerCase().contains(ingredient.toLowerCase()));
                                                })
                                                .map((ingredient) {
                                              final isSelected = selectedIngredients.contains(ingredient);

                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (isSelected) {
                                                      selectedIngredients.remove(ingredient);
                                                    } else {
                                                      selectedIngredients.add(ingredient);
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: isSelected ? Colors.black : cardColor, // Toggle color
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(
                                                      color: borderColor!,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      ingredient,
                                                      style: TextStyle(
                                                        color: isSelected ? Colors.white : textColor, // Toggle text color
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    )
                                  : selectedTab == 5
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.arrow_back, color: textColor),
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedTab = 1; // Go back to the ingredients tab
                                                    });
                                                  },
                                                ),
                                                Text(
                                                  'Recipes You Can Make',
                                                  style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: GridView.count(
                                                crossAxisCount: 3,
                                                mainAxisSpacing: 20,
                                                crossAxisSpacing: 20,
                                                padding: const EdgeInsets.all(20),
                                                children: getFilteredRecipes().map((recipe) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      switchToRecipeDetails(recipe);
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            color: cardColor,
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                        ),
                                                        Positioned.fill(
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.menu_book,
                                                              color: isDarkMode ? Colors.white : Colors.grey[700],
                                                              size: 50,
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 8,
                                                          left: 0,
                                                          right: 0,
                                                          child: Text(
                                                            recipe,
                                                            style: TextStyle(
                                                              color: textColor,
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                              shadows: [
                                                                Shadow(
                                                                  blurRadius: 4,
                                                                  color: borderColor!,
                                                                  offset: Offset(2, 2),
                                                                ),
                                                              ],
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ],
                                        )
                                      : selectedTab == 6
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(Icons.arrow_back, color: textColor),
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedTab = 0; // Go back to the recipe book
                                                        });
                                                      },
                                                    ),
                                                    Text(
                                                      'Recipe Roulette',
                                                      style: TextStyle(
                                                        color: textColor,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                buildMealTypeFilters(), // Add filters here
                                                const SizedBox(height: 10),
                                                Expanded(
                                                  child: Center(
                                                    child: isSpinning
                                                        ? Text(
                                                            selectedRecipe,
                                                            style: TextStyle(
                                                              color: textColor,
                                                              fontSize: 24,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          )
                                                        : Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: selectedRecipe.isNotEmpty
                                                                    ? () {
                                                                        switchToRecipeDetails(selectedRecipe); // Navigate to recipe details
                                                                      }
                                                                    : null,
                                                                child: Text(
                                                                  selectedRecipe.isNotEmpty
                                                                      ? selectedRecipe
                                                                      : 'Press the button to spin!',
                                                                  style: TextStyle(
                                                                    color: textColor,
                                                                    fontSize: 24,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 20),
                                                              ElevatedButton.icon(
                                                                onPressed: startRoulette,
                                                                icon: const Icon(Icons.casino),
                                                                label: const Text('Spin the Roulette'),
                                                                style: ElevatedButton.styleFrom(
                                                                  padding: const EdgeInsets.symmetric(
                                                                      horizontal: 20, vertical: 10),
                                                                  textStyle: const TextStyle(fontSize: 18),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : selectedTab == 2
                                              ? savedRecipes.isEmpty
                                                  ? Center(
                                                      child: Text(
                                                        'No saved recipes yet.',
                                                        style: TextStyle(
                                                          color: textColor,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    )
                                                  : ListView.builder(
                                                      padding: const EdgeInsets.all(16.0),
                                                      itemCount: savedRecipes.length,
                                                      itemBuilder: (context, index) {
                                                        final recipe = savedRecipes[index];
                                                        return Card(
                                                          color: cardColor,
                                                          child: ListTile(
                                                            title: Text(
                                                              recipe,
                                                              style: TextStyle(
                                                                color: textColor,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              switchToRecipeDetails(recipe);
                                                            },
                                                            trailing: IconButton(
                                                              icon: const Icon(Icons.delete, color: Colors.red),
                                                              onPressed: () {
                                                                setState(() {
                                                                  savedRecipes.remove(recipe);
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    )
                                              : selectedTab == 8
                                                  ? Container(
                                                      padding: const EdgeInsets.all(16),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            'Recipe Timers',
                                                            style: TextStyle(
                                                              color: textColor,
                                                              fontSize: 24,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 20),
                                                          Expanded(
                                                            child: ListView(
                                                              children: [
                                                                Card(
                                                                  child: ListTile(
                                                                    title: const Text('Add Timer'),
                                                                    leading: const Icon(Icons.add),
                                                                    onTap: () {
                                                                      showDialog(
                                                                        context: context,
                                                                        builder: (context) {
                                                                          String name = '';
                                                                          final ValueNotifier<int> hours = ValueNotifier(0);
                                                                          final ValueNotifier<int> minutes = ValueNotifier(0);
                                                                    
                                                                          return StatefulBuilder(
                                                                            builder: (context, setDialogState) {
                                                                              return AlertDialog(
                                                                                title: const Text('Add Timer'),
                                                                                content: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    TextField(
                                                                                      decoration: const InputDecoration(
                                                                                        labelText: 'Timer Name',
                                                                                      ),
                                                                                      onChanged: (value) => name = value,
                                                                                    ),
                                                                                    const SizedBox(height: 20),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                      children: [
                                                                                        Column(
                                                                                          children: [
                                                                                            const Text('Hours'),
                                                                                            Row(
                                                                                              children: [
                                                                                                IconButton(
                                                                                                  icon: const Icon(Icons.remove),
                                                                                                  onPressed: () {
                                                                                                    setDialogState(() {
                                                                                                      if (hours.value > 0) hours.value--;
                                                                                                    });
                                                                                                  },
                                                                                                ),
                                                                                                ValueListenableBuilder(
                                                                                                  valueListenable: hours,
                                                                                                  builder: (context, value, child) => 
                                                                                                    Text('$value', style: const TextStyle(fontSize: 20)),
                                                                                                ),
                                                                                                IconButton(
                                                                                                  icon: const Icon(Icons.add),
                                                                                                  onPressed: () {
                                                                                                    setDialogState(() {
                                                                                                      hours.value++;
                                                                                                    });
                                                                                                  },
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        Column(
                                                                                          children: [
                                                                                            const Text('Minutes'),
                                                                                            Row(
                                                                                              children: [
                                                                                                IconButton(
                                                                                                  icon: const Icon(Icons.remove),
                                                                                                  onPressed: () {
                                                                                                    setDialogState(() {
                                                                                                      if (minutes.value > 0) minutes.value--;
                                                                                                    });
                                                                                                  },
                                                                                                ),
                                                                                                ValueListenableBuilder(
                                                                                                  valueListenable: minutes,
                                                                                                  builder: (context, value, child) => 
                                                                                                    Text('$value', style: const TextStyle(fontSize: 20)),
                                                                                                ),
                                                                                                IconButton(
                                                                                                  icon: const Icon(Icons.add),
                                                                                                  onPressed: () {
                                                                                                    setDialogState(() {
                                                                                                      if (minutes.value < 59) minutes.value++;
                                                                                                      else {
                                                                                                        minutes.value = 0;
                                                                                                        hours.value++;
                                                                                                      }
                                                                                                    });
                                                                                                  },
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                actions: [
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(context),
                                                                                    child: const Text('Cancel'),
                                                                                  ),
                                                                                  TextButton(
                                                                                    onPressed: () {
                                                                                      if (name.isNotEmpty && (hours.value > 0 || minutes.value > 0)) {
                                                                                        startTimer(name, (hours.value * 3600) + (minutes.value * 60));
                                                                                        Navigator.pop(context);
                                                                                      }
                                                                                    },
                                                                                    child: const Text('Start'),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                                ...activeTimers.keys.map((name) {
                                                                  final remaining = timerDurations[name]!;
                                                                  final hours = remaining ~/ 3600;
                                                                  final minutes = (remaining % 3600) ~/ 60;
                                                                  final seconds = remaining % 60;
                                                                  final timeString = hours > 0 
                                                                      ? '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'
                                                                      : '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
                                                                  return Card(
                                                                    child: ListTile(
                                                                      title: Text(name),
                                                                      subtitle: Text(timeString),
                                                                      trailing: IconButton(
                                                                        icon: const Icon(Icons.stop),
                                                                        onPressed: () {
                                                                          activeTimers[name]?.cancel();
                                                                          setState(() {
                                                                            activeTimers.remove(name);
                                                                            timerDurations.remove(name);
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : selectedTab == 9
                                                      ? Container(
                                                          padding: const EdgeInsets.all(16),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'Settings',
                                                                style: TextStyle(
                                                                  color: textColor,
                                                                  fontSize: 24,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 20),
                                                              Card(
                                                                child: ListTile(
                                                                  title: const Text('Dark Mode'),
                                                                  trailing: Switch(
                                                                    value: isDarkMode,
                                                                    onChanged: (value) {
                                                                      setState(() {
                                                                        isDarkMode = value;
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              Card(
                                                                child: ListTile(
                                                                  title: const Text('Font Size'),
                                                                  trailing: DropdownButton<double>(
                                                                    value: fontSize,
                                                                    items: [14.0, 16.0, 18.0, 20.0]
                                                                        .map((size) => DropdownMenuItem(
                                                                              value: size,
                                                                              child: Text('${size.toInt()}'),
                                                                            ))
                                                                        .toList(),
                                                                    onChanged: (value) {
                                                                      if (value != null) {
                                                                        setState(() {
                                                                          fontSize = value;
                                                                        });
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              Card(
                                                                child: ListTile(
                                                                  title: const Text('Language'),
                                                                  trailing: DropdownButton<String>(
                                                                    value: selectedLanguage,
                                                                    items: ['English', 'Arabic', 'French', 'Spanish']
                                                                        .map((lang) => DropdownMenuItem(
                                                                              value: lang,
                                                                              child: Text(lang),
                                                                            ))
                                                                        .toList(),
                                                                    onChanged: (value) {
                                                                      if (value != null) {
                                                                        setState(() {
                                                                          selectedLanguage = value;
                                                                        });
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Stack(
                                                          children: [
                                                            Center(
                                                              child: Text(
                                                                'Help Room',
                                                                style: TextStyle(
                                                                  color: textColor,
                                                                  fontSize: 24,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
