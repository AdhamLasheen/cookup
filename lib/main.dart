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
  String selectedMealType = ''; // To store the selected meal type (breakfast, lunch, dinner, or dessert)
  final List<String> selectedIngredients = []; // List to store clicked ingredients
  final List<String> savedRecipes = []; // List to store saved recipes
  String searchQuery = ''; // Store the search query
  bool isSpinning = false; // Track if the roulette is spinning

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

  void switchToRecipeDetails(String recipeName) {
    setState(() {
      selectedTab = 4; // New tab for recipe details
      selectedRecipe = recipeName; // Store the selected recipe name
    });
  }

  void switchToFilteredRecipes() {
    setState(() {
      selectedTab = 5; // New tab for filtered recipes
    });
  }

  void switchToRecipeRoulette() {
    setState(() {
      selectedTab = 6; // New tab for Recipe Roulette
      selectedRecipe = ''; // Reset the recipe when entering the tab
    });
  }

  void startRoulette() async {
    setState(() {
      isSpinning = true;
    });

    final recipes = recipeDetails.keys.toList();
    for (int i = 0; i < 20; i++) {
      await Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          selectedRecipe = recipes[i % recipes.length]; // Cycle through recipes
        });
      });
    }

    setState(() {
      isSpinning = false; // Stop spinning
    });
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
    return recipeDetails.keys.where((recipe) {
      final ingredients = recipeDetails[recipe]?['ingredients']?.toLowerCase() ?? '';
      final mealType = recipeDetails[recipe]?['mealType']?.toLowerCase() ?? '';

      // If a meal type is selected, filter by it
      if (selectedMealType.isNotEmpty && mealType != selectedMealType) {
        return false;
      }

      final requiredIngredients = ingredients
          .split('\n')
          .map((line) => line.replaceAll(RegExp(r'^-\s*'), ''))
          .map((line) => line.split(' ').skip(1).join(' '))
          .map((line) => line.trim().toLowerCase())
          .where((line) => line.isNotEmpty)
          .toList();

      return requiredIngredients.every((ingredient) {
        return selectedIngredients.any((selected) =>
            ingredient.contains(selected.toLowerCase()) || selected.toLowerCase().contains(ingredient));
      });
    }).toList();
  }

  String selectedRecipe = ''; // Store the selected recipe name

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
                            title: Text('recipe roulette'),
                            leading: const Icon(Icons.casino),
                            onTap: switchToRecipeRoulette,
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
                                  color: Colors.black, // Text color set to black
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Ingredient Room\n'
                                'Select the ingredients you currently have. You can search for items, add them to your list, and remove them anytime.\n',
                                style: TextStyle(
                                  color: Colors.black, // Text color set to black
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Recipe Room\n'
                                'Get recipe suggestions based on the ingredients you\'ve selected. The more you add, the more personalized the results.\n',
                                style: TextStyle(
                                  color: Colors.black, // Text color set to black
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Saved Recipe Room\n'
                                'Save your favorite recipes so you can find them easily later.\n',
                                style: TextStyle(
                                  color: Colors.black, // Text color set to black
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Help Room (You\'re here)\n'
                                'Use this space to get guidance, ask questions, or report any issues you’re having with the app.',
                                style: TextStyle(
                                  color: Colors.black, // Text color set to black
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
                                    style: const TextStyle(color: Colors.black), // Set text color to black
                                    decoration: InputDecoration(
                                      hintText: 'Search recipes...',
                                      hintStyle: const TextStyle(color: Colors.grey), // Hint text color
                                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
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
                                                recipe,
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
                                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                                          onPressed: () {
                                            setState(() {
                                              selectedTab = 6;
                                            });
                                          },
                                        ),
                                        const Expanded(
                                          child: Text(
                                            'Recipe Details',
                                            style: TextStyle(
                                              color: Colors.white,
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
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Recipe: $selectedRecipe',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Ingredients:\n${recipeDetails[selectedRecipe]?['ingredients'] ?? ''}',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Instructions:\n${recipeDetails[selectedRecipe]?['instructions'] ?? ''}',
                                              style: const TextStyle(
                                                color: Colors.black,
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
                                            color: Colors.white, // Changed to white
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.grey[400]!, width: 2),
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
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(8),
                                                      border: Border.all(
                                                        color: Colors.grey[400]!,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      ingredient,
                                                      style: const TextStyle(
                                                        color: Colors.black,
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
                                            child: const Text(
                                              'Search for Recipes',
                                              style: TextStyle(
                                                color: Colors.black,
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
                                            children: allIngredients.map((ingredient) {
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
                                                    color: isSelected ? Colors.black : Colors.white, // Toggle color
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(
                                                      color: Colors.grey[400]!,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      ingredient,
                                                      style: TextStyle(
                                                        color: isSelected ? Colors.white : Colors.black, // Toggle text color
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
                                                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedTab = 1; // Go back to the ingredients tab
                                                    });
                                                  },
                                                ),
                                                const Text(
                                                  'Recipes You Can Make',
                                                  style: TextStyle(
                                                    color: Colors.white,
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
                                                            recipe,
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
                                                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedTab = 0; // Go back to the recipe book
                                                        });
                                                      },
                                                    ),
                                                    const Text(
                                                      'Recipe Roulette',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: isSpinning
                                                        ? Text(
                                                            selectedRecipe,
                                                            style: const TextStyle(
                                                              color: Colors.black,
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
                                                                  style: const TextStyle(
                                                                    color: Colors.black,
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
                                                  ? const Center(
                                                      child: Text(
                                                        'No saved recipes yet.',
                                                        style: TextStyle(
                                                          color: Colors.white,
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
                                                          color: Colors.white,
                                                          child: ListTile(
                                                            title: Text(
                                                              recipe,
                                                              style: const TextStyle(
                                                                color: Colors.black,
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
                                              : const Stack(
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        'Help Room',
                                                        style: TextStyle(
                                                          color: Colors.white,
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
