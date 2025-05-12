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

  List<String> getFilteredRecipes() {
    return recipeDetails.keys.where((recipe) {
      final ingredients = recipeDetails[recipe]?['ingredients']?.toLowerCase() ?? '';
      // Check if at least one selected ingredient matches the recipe's ingredients
      return selectedIngredients.any((ingredient) => ingredients.contains(ingredient.toLowerCase()));
    }).toList();
  }

  String selectedRecipe = ''; // Store the selected recipe name

  Map<String, Map<String, dynamic>> recipeDetails = {
    'Eggs': {
      'ingredients': '- 2 Eggs\n- Salt\n- Pepper\n- Butter',
      'instructions': '1. Heat a pan over medium heat.\n'
          '2. Add butter to the pan.\n'
          '3. Crack the eggs into the pan.\n'
          '4. Sprinkle salt and pepper.\n'
          '5. Cook until desired doneness.',
    },
    'Mashed Potatoes': {
      'ingredients': '- 4 Potatoes\n- Butter\n- Milk\n- Salt\n- Pepper',
      'instructions': '1. Peel and boil the potatoes until soft.\n'
          '2. Mash the potatoes.\n'
          '3. Add butter, milk, salt, and pepper.\n'
          '4. Mix until smooth.',
    },
    'Steak': {
      'ingredients': '- 1 Steak\n- Salt\n- Pepper\n- Olive Oil',
      'instructions': '1. Season the steak with salt and pepper.\n'
          '2. Heat olive oil in a pan over high heat.\n'
          '3. Cook the steak to your desired doneness.\n'
          '4. Let it rest before serving.',
    },
    'Grilled Cheese': {
      'ingredients': '- 2 Slices of Bread\n- Butter\n- 2 Slices of Cheese',
      'instructions': '1. Butter one side of each slice of bread.\n'
          '2. Place cheese between the unbuttered sides.\n'
          '3. Grill in a pan until golden brown on both sides.',
    },
    'Boiled Eggs': {
      'ingredients': '- 2 Eggs\n- Water\n- Salt',
      'instructions': '1. Place eggs in a pot and cover with water.\n'
          '2. Bring to a boil and cook for 6-10 minutes.\n'
          '3. Cool in ice water before peeling.',
    },
    'Chicken': {
      'ingredients': '- 1 Chicken Breast\n- Salt\n- Pepper\n- Olive Oil',
      'instructions': '1. Season the chicken with salt and pepper.\n'
          '2. Heat olive oil in a pan over medium heat.\n'
          '3. Cook the chicken until fully cooked.\n'
          '4. Let it rest before serving.',
    },
    'Pancakes': {
      'ingredients': '- 1 Cup Flour\n- 1 Cup Milk\n- 1 Egg\n- 2 Tbsp Sugar\n- 1 Tsp Baking Powder\n- Butter',
      'instructions': '1. Mix flour, sugar, and baking powder in a bowl.\n'
          '2. Add milk and egg, and whisk until smooth.\n'
          '3. Heat a pan and add butter.\n'
          '4. Pour batter into the pan and cook until bubbles form.\n'
          '5. Flip and cook until golden brown.',
    },
    'Spaghetti': {
      'ingredients': '- 200g Spaghetti\n- 1 Cup Tomato Sauce\n- 2 Garlic Cloves\n- Olive Oil\n- Salt\n- Parmesan Cheese',
      'instructions': '1. Boil spaghetti in salted water until al dente.\n'
          '2. Heat olive oil in a pan and sauté garlic.\n'
          '3. Add tomato sauce and simmer.\n'
          '4. Toss spaghetti in the sauce.\n'
          '5. Serve with grated Parmesan cheese.',
    },
    'Caesar Salad': {
      'ingredients': '- 1 Romaine Lettuce\n- Croutons\n- Caesar Dressing\n- Parmesan Cheese\n- Grilled Chicken (optional)',
      'instructions': '1. Chop romaine lettuce and place in a bowl.\n'
          '2. Add croutons and Parmesan cheese.\n'
          '3. Toss with Caesar dressing.\n'
          '4. Add grilled chicken if desired.',
    },
    'Brownies': {
      'ingredients': '- 1/2 Cup Butter\n- 1 Cup Sugar\n- 2 Eggs\n- 1/3 Cup Cocoa Powder\n- 1/2 Cup Flour\n- 1 Tsp Vanilla Extract',
      'instructions': '1. Melt butter and mix with sugar.\n'
          '2. Add eggs and vanilla extract, and whisk.\n'
          '3. Stir in cocoa powder and flour.\n'
          '4. Pour batter into a greased pan.\n'
          '5. Bake at 350°F (175°C) for 20-25 minutes.',
    },
    'Tacos': {
      'ingredients': '- 4 Taco Shells\n- 200g Ground Beef\n- 1/2 Cup Lettuce\n- 1/2 Cup Tomato\n- 1/4 Cup Cheese\n- Taco Seasoning',
      'instructions': '1. Cook ground beef with taco seasoning.\n'
          '2. Chop lettuce and tomato.\n'
          '3. Fill taco shells with beef, lettuce, tomato, and cheese.\n'
          '4. Serve immediately.',
    },
    'French Toast': {
      'ingredients': '- 4 Slices of Bread\n- 2 Eggs\n- 1/2 Cup Milk\n- 1 Tsp Vanilla Extract\n- Butter\n- Syrup',
      'instructions': '1. Whisk eggs, milk, and vanilla extract in a bowl.\n'
          '2. Dip bread slices into the mixture.\n'
          '3. Heat butter in a pan and cook bread until golden brown on both sides.\n'
          '4. Serve with syrup.',
    },
    'Vegetable Stir Fry': {
      'ingredients': '- 1 Cup Broccoli\n- 1 Cup Carrots\n- 1 Cup Bell Peppers\n- 2 Tbsp Soy Sauce\n- 1 Tbsp Olive Oil\n- Garlic',
      'instructions': '1. Heat olive oil in a pan.\n'
          '2. Add garlic and sauté for 1 minute.\n'
          '3. Add vegetables and stir fry for 5-7 minutes.\n'
          '4. Add soy sauce and cook for another 2 minutes.\n'
          '5. Serve hot.',
    },
    'Banana Smoothie': {
      'ingredients': '- 2 Bananas\n- 1 Cup Milk\n- 1 Tbsp Honey\n- Ice Cubes',
      'instructions': '1. Add bananas, milk, honey, and ice cubes to a blender.\n'
          '2. Blend until smooth.\n'
          '3. Serve immediately.',
    },
    'Chocolate Chip Cookies': {
      'ingredients': '- 1/2 Cup Butter\n- 1/2 Cup Sugar\n- 1/2 Cup Brown Sugar\n- 1 Egg\n- 1 Tsp Vanilla Extract\n- 1 1/4 Cups Flour\n- 1/2 Tsp Baking Soda\n- 1 Cup Chocolate Chips',
      'instructions': '1. Cream butter, sugar, and brown sugar together.\n'
          '2. Add egg and vanilla extract, and mix well.\n'
          '3. Stir in flour and baking soda.\n'
          '4. Fold in chocolate chips.\n'
          '5. Drop spoonfuls onto a baking sheet and bake at 350°F (175°C) for 10-12 minutes.',
    },
    'Mac and Cheese': {
      'ingredients': '- 200g Macaroni\n- 1 Cup Milk\n- 1 Cup Cheddar Cheese\n- 2 Tbsp Butter\n- 1 Tbsp Flour\n- Salt\n- Pepper',
      'instructions': '1. Cook macaroni in salted water until al dente.\n'
          '2. In a pan, melt butter and stir in flour to make a roux.\n'
          '3. Gradually add milk, stirring constantly.\n'
          '4. Add cheese and stir until melted.\n'
          '5. Mix the cheese sauce with the macaroni and serve.',
    },
    'Stuffed Bell Peppers': {
      'ingredients': '- 4 Bell Peppers\n- 200g Ground Beef\n- 1 Cup Cooked Rice\n- 1/2 Cup Tomato Sauce\n- 1/4 Cup Cheese\n- Salt\n- Pepper',
      'instructions': '1. Cut the tops off the bell peppers and remove seeds.\n'
          '2. Cook ground beef and mix with rice, tomato sauce, salt, and pepper.\n'
          '3. Stuff the mixture into the bell peppers.\n'
          '4. Bake at 375°F (190°C) for 25-30 minutes.\n'
          '5. Sprinkle cheese on top and bake for another 5 minutes.',
    },
    'Lemonade': {
      'ingredients': '- 4 Lemons\n- 1/2 Cup Sugar\n- 4 Cups Water\n- Ice Cubes',
      'instructions': '1. Squeeze the juice from the lemons.\n'
          '2. Mix lemon juice, sugar, and water in a pitcher.\n'
          '3. Stir until the sugar dissolves.\n'
          '4. Add ice cubes and serve chilled.',
    },
    'Chicken Alfredo': {
      'ingredients': '- 200g Fettuccine\n- 1 Chicken Breast\n- 1 Cup Heavy Cream\n- 1/2 Cup Parmesan Cheese\n- 2 Tbsp Butter\n- Garlic\n- Salt\n- Pepper',
      'instructions': '1. Cook fettuccine in salted water until al dente.\n'
          '2. Cook chicken breast in a pan and slice it.\n'
          '3. In the same pan, melt butter and sauté garlic.\n'
          '4. Add heavy cream and Parmesan cheese, and stir until smooth.\n'
          '5. Toss the pasta in the sauce and top with chicken slices.',
    },
    'Fruit Salad': {
      'ingredients': '- 1 Apple\n- 1 Banana\n- 1 Orange\n- 1/2 Cup Grapes\n- 1 Tbsp Honey\n- 1 Tbsp Lemon Juice',
      'instructions': '1. Chop all fruits into bite-sized pieces.\n'
          '2. Mix honey and lemon juice in a bowl.\n'
          '3. Toss the fruits in the honey-lemon mixture.\n'
          '4. Serve immediately or chill before serving.',
    },
    'Tomato Soup': {
      'ingredients': '- 4 Tomatoes\n- 1 Onion\n- 2 Garlic Cloves\n- 2 Cups Vegetable Broth\n- Salt\n- Pepper\n- Olive Oil',
      'instructions': '1. Sauté onion and garlic in olive oil.\n'
          '2. Add chopped tomatoes and cook for 5 minutes.\n'
          '3. Add vegetable broth, salt, and pepper.\n'
          '4. Simmer for 15 minutes and blend until smooth.\n'
          '5. Serve hot.',
    },
    'Garlic Bread': {
      'ingredients': '- 1 Baguette\n- 1/4 Cup Butter\n- 2 Garlic Cloves\n- Parsley',
      'instructions': '1. Mix softened butter with minced garlic and chopped parsley.\n'
          '2. Spread the mixture on sliced baguette.\n'
          '3. Bake at 375°F (190°C) for 10 minutes.\n'
          '4. Serve warm.',
    },
    'Beef Stroganoff': {
      'ingredients': '- 200g Beef Strips\n- 1 Cup Mushrooms\n- 1 Onion\n- 1 Cup Sour Cream\n- 1 Tbsp Flour\n- Butter\n- Salt\n- Pepper',
      'instructions': '1. Sauté beef strips in butter and set aside.\n'
          '2. Cook onions and mushrooms in the same pan.\n'
          '3. Add flour and stir, then add sour cream.\n'
          '4. Return beef to the pan and simmer for 10 minutes.\n'
          '5. Serve over rice or noodles.',
    },
    'Shrimp Scampi': {
      'ingredients': '- 200g Shrimp\n- 3 Garlic Cloves\n- 1/4 Cup Butter\n- 1/4 Cup White Wine\n- Lemon Juice\n- Parsley\n- Salt\n- Pepper',
      'instructions': '1. Sauté garlic in butter.\n'
          '2. Add shrimp and cook until pink.\n'
          '3. Add white wine, lemon juice, salt, and pepper.\n'
          '4. Simmer for 5 minutes and garnish with parsley.\n'
          '5. Serve over pasta or rice.',
    },
    'Vegetable Curry': {
      'ingredients': '- 1 Cup Cauliflower\n- 1 Cup Potatoes\n- 1 Cup Peas\n- 1 Onion\n- 1 Cup Coconut Milk\n- Curry Powder\n- Salt\n- Oil',
      'instructions': '1. Sauté onion in oil.\n'
          '2. Add cauliflower, potatoes, and peas.\n'
          '3. Stir in curry powder and cook for 2 minutes.\n'
          '4. Add coconut milk and simmer for 15 minutes.\n'
          '5. Serve with rice or naan.',
    },
    'Apple Pie': {
      'ingredients': '- 2 Apples\n- 1/2 Cup Sugar\n- 1 Tsp Cinnamon\n- 1 Pie Crust\n- Butter',
      'instructions': '1. Slice apples and mix with sugar and cinnamon.\n'
          '2. Place the mixture in a pie crust.\n'
          '3. Dot with butter and cover with another crust.\n'
          '4. Bake at 375°F (190°C) for 40 minutes.\n'
          '5. Serve warm.',
    },
    'Fried Rice': {
      'ingredients': '- 2 Cups Cooked Rice\n- 1 Cup Mixed Vegetables\n- 2 Eggs\n- Soy Sauce\n- Sesame Oil\n- Garlic',
      'instructions': '1. Heat sesame oil in a pan.\n'
          '2. Sauté garlic and mixed vegetables.\n'
          '3. Push vegetables to the side and scramble eggs.\n'
          '4. Add rice and soy sauce, and stir-fry for 5 minutes.\n'
          '5. Serve hot.',
    },
    'Chicken Soup': {
      'ingredients': '- 1 Chicken Breast\n- 2 Carrots\n- 2 Celery Stalks\n- 1 Onion\n- 4 Cups Chicken Broth\n- Salt\n- Pepper',
      'instructions': '1. Cook chicken breast in chicken broth.\n'
          '2. Remove chicken and shred it.\n'
          '3. Add chopped carrots, celery, and onion to the broth.\n'
          '4. Simmer for 15 minutes and return chicken to the pot.\n'
          '5. Serve hot.',
    },
    'Fish Tacos': {
      'ingredients': '- 4 Taco Shells\n- 200g Fish Fillets\n- 1/2 Cup Cabbage\n- 1/4 Cup Sour Cream\n- Lime Juice\n- Salt\n- Pepper',
      'instructions': '1. Season fish with salt and pepper and cook in a pan.\n'
          '2. Mix sour cream with lime juice.\n'
          '3. Fill taco shells with fish, cabbage, and sour cream.\n'
          '4. Serve immediately.',
    },
    'Omelette': {
      'ingredients': '- 2 Eggs\n- 1/4 Cup Cheese\n- 1/4 Cup Bell Peppers\n- Salt\n- Pepper\n- Butter',
      'instructions': '1. Whisk eggs with salt and pepper.\n'
          '2. Heat butter in a pan and pour in the eggs.\n'
          '3. Add cheese and bell peppers.\n'
          '4. Fold the omelette and cook until set.\n'
          '5. Serve hot.',
    },
    'Lasagna': {
      'ingredients': '- 6 Lasagna Noodles\n- 1 Cup Ricotta Cheese\n- 1 Cup Mozzarella Cheese\n- 1 Cup Tomato Sauce\n- 200g Ground Beef\n- Salt\n- Pepper',
      'instructions': '1. Cook lasagna noodles.\n'
          '2. Cook ground beef with tomato sauce, salt, and pepper.\n'
          '3. Layer noodles, ricotta, mozzarella, and beef sauce in a baking dish.\n'
          '4. Bake at 375°F (190°C) for 30 minutes.\n'
          '5. Serve hot.',
    },
    'Caprese Salad': {
      'ingredients': '- 2 Tomatoes\n- 1/2 Cup Mozzarella Cheese\n- Basil Leaves\n- Olive Oil\n- Balsamic Glaze\n- Salt\n- Pepper',
      'instructions': '1. Slice tomatoes and mozzarella.\n'
          '2. Arrange on a plate with basil leaves.\n'
          '3. Drizzle with olive oil and balsamic glaze.\n'
          '4. Sprinkle with salt and pepper.\n'
          '5. Serve immediately.',
    },
    'Pesto Pasta': {
      'ingredients': '- 200g Pasta\n- 1/2 Cup Basil Pesto\n- 1/4 Cup Parmesan Cheese\n- Olive Oil\n- Salt\n- Pepper',
      'instructions': '1. Cook pasta in salted water until al dente.\n'
          '2. Toss pasta with basil pesto and olive oil.\n'
          '3. Sprinkle with Parmesan cheese.\n'
          '4. Serve hot.',
    },
    'Blueberry Muffins': {
      'ingredients': '- 1 1/2 Cups Flour\n- 1/2 Cup Sugar\n- 1/2 Cup Milk\n- 1/4 Cup Butter\n- 1 Egg\n- 1 Cup Blueberries\n- 1 Tsp Baking Powder',
      'instructions': '1. Mix flour, sugar, and baking powder in a bowl.\n'
          '2. Add milk, melted butter, and egg, and mix until smooth.\n'
          '3. Fold in blueberries.\n'
          '4. Pour batter into muffin tins and bake at 375°F (190°C) for 20 minutes.\n'
          '5. Serve warm.',
    },
    'Chili': {
      'ingredients': '- 200g Ground Beef\n- 1 Cup Kidney Beans\n- 1 Cup Tomato Sauce\n- 1 Onion\n- Chili Powder\n- Salt\n- Pepper',
      'instructions': '1. Cook ground beef with chopped onion.\n'
          '2. Add kidney beans, tomato sauce, chili powder, salt, and pepper.\n'
          '3. Simmer for 20 minutes.\n'
          '4. Serve hot.',
    },
    'Greek Salad': {
      'ingredients': '- 1 Cucumber\n- 2 Tomatoes\n- 1/2 Cup Feta Cheese\n- 1/4 Cup Olives\n- Olive Oil\n- Lemon Juice\n- Salt\n- Pepper',
      'instructions': '1. Chop cucumber and tomatoes.\n'
          '2. Mix with feta cheese and olives.\n'
          '3. Drizzle with olive oil and lemon juice.\n'
          '4. Sprinkle with salt and pepper.\n'
          '5. Serve chilled.',
    },
    'Pumpkin Pie': {
      'ingredients': '- 1 Pie Crust\n- 1 Cup Pumpkin Puree\n- 1/2 Cup Sugar\n- 1/2 Cup Milk\n- 2 Eggs\n- 1 Tsp Cinnamon\n- Nutmeg',
      'instructions': '1. Mix pumpkin puree, sugar, milk, eggs, cinnamon, and nutmeg.\n'
          '2. Pour into a pie crust.\n'
          '3. Bake at 375°F (190°C) for 40 minutes.\n'
          '4. Serve chilled.',
    },
    'Quesadilla': {
      'ingredients': '- 2 Tortillas\n- 1/2 Cup Cheese\n- 1/4 Cup Bell Peppers\n- 1/4 Cup Chicken (optional)\n- Butter',
      'instructions': '1. Heat a tortilla in a pan with butter.\n'
          '2. Add cheese, bell peppers, and chicken (if using).\n'
          '3. Top with another tortilla and cook until golden brown.\n'
          '4. Flip and cook the other side.\n'
          '5. Serve hot.',
    },
    'Smoothie Bowl': {
      'ingredients': '- 1 Banana\n- 1/2 Cup Berries\n- 1/2 Cup Yogurt\n- Granola\n- Honey',
      'instructions': '1. Blend banana, berries, and yogurt until smooth.\n'
          '2. Pour into a bowl and top with granola and honey.\n'
          '3. Serve immediately.',
    },
    'Chicken Tikka': {
      'ingredients': '- 200g Chicken\n- 1/2 Cup Yogurt\n- 1 Tsp Garam Masala\n- 1 Tsp Paprika\n- Lemon Juice\n- Salt\n- Pepper',
      'instructions': '1. Marinate chicken in yogurt, garam masala, paprika, lemon juice, salt, and pepper for 1 hour.\n'
          '2. Cook chicken in a pan or grill until fully cooked.\n'
          '3. Serve hot.',
    },
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
                                Expanded(
                                  child: GridView.count(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 20,
                                    padding: const EdgeInsets.all(20),
                                    children: recipeDetails.keys
                                        .where((recipe) => recipe.toLowerCase().contains(searchQuery))
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
                                              selectedTab = 6; // Go back to the Recipe Roulette tab
                                            });
                                          },
                                        ),
                                        const Text(
                                          'Recipe Details',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
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
