import 'package:cookup/data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:cookup/services/unsplash_service.dart';
import 'dart:ui';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home:  Home(
        isDarkMode: isDarkMode,
        onThemeChanged: (value) {
          setState(() {
            isDarkMode = value;
          });
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key, required this.isDarkMode, required this.onThemeChanged});
  final bool isDarkMode ;
  final ValueChanged<bool> onThemeChanged;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int selectedTab = 0;
  String selectedMealType = '';
  final List<String> selectedIngredients = [];
  final List<String> savedRecipes = [];

  String searchQuery = '';
  bool isSpinning = false;
  Map<String, Timer> activeTimers = {};
  Map<String, int> timerDurations = {};
  String selectedLanguage = 'English';
  final Map<String, String> recipeImages = {};
  String? lastRecipe; // Add this line after selectedRecipe declaration
  bool useMinimumIngredients = true; // Changed to true by default
  String ingredientSortMode = 'alphabetical'; // Add this with other state variables

  // New state variables for filters
  String selectedDifficulty = '';
  String selectedCuisine = '';
  String selectedCalorieRange = '';
  String selectedTimeRange = '';
  int calorieLimit = 2000; // Add this with other state variables

  // Replace these state variables
  Map<String, List<String>> weeklyMeals = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };
  // int? selectedMealSlot;  // Removed duplicate declaration

  late TabController _ingredientsTabController;
  late TextEditingController _calorieLimitController;

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
      'recipe_details': 'Recipe Details',
      'recipe_prefix': 'Recipe:',
      'ingredients_prefix': 'Ingredients:',
      'instructions_prefix': 'Instructions:',
      'search_recipes_hint': 'Search recipes...',
      'no_saved_recipes': 'No saved recipes yet.',
      'contains': 'Contains:',
      'press_spin': 'Press the button to spin!',
      'spin_button': 'Spin the Roulette',
      'add_timer': 'Add Timer',
      'timer_name': 'Timer Name',
      'hours': 'Hours',
      'minutes': 'Minutes',
      'start': 'Start',
      'cancel': 'Cancel',
      'breakfast': 'Breakfast',
      'lunch': 'Lunch',
      'dinner': 'Dinner',
      'dessert': 'Dessert',
      'kitchen_tools': 'Kitchen Tools',
      'cup_converter': 'Cup Converter',
      'convert_from': 'Convert from',
      'convert_to': 'Convert to',
      'amount': 'Amount',
      'convert': 'Convert',
      'result': 'Result',
      'cups': 'Cups',
      'milliliters': 'Milliliters',
      'fluid_ounces': 'Fluid Ounces',
      'tablespoons': 'Tablespoons',
      'teaspoons': 'Teaspoons',
      'cuisine': 'Cuisine',
      'difficulty': 'Difficulty',
      'cooking_time': 'Cooking Time',
      'calories': 'Calories',
      'servings': 'Servings',
      'easy': 'Easy',
      'medium': 'Medium',
      'hard': 'Hard',
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
      'recipe_details': 'تفاصيل الوصفة',
      'recipe_prefix': 'الوصفة:',
      'ingredients_prefix': 'المكونات:',
      'instructions_prefix': 'التعليمات:',
      'search_recipes_hint': 'البحث عن الوصفات...',
      'no_saved_recipes': 'لا توجد وصفات محفوظة بعد.',
      'contains': 'يحتوي على:',
      'press_spin': 'اضغط على الزر للدوران!',
      'spin_button': 'تدوير العجلة',
      'add_timer': 'إضافة مؤقت',
      'timer_name': 'اسم المؤقت',
      'hours': 'ساعات',
      'minutes': 'دقائق',
      'start': 'بدء',
      'cancel': 'إلغاء',
      'breakfast': 'فطور',
      'lunch': 'غداء',
      'dinner': 'عشاء',
      'dessert': 'حلويات',
      'cuisine': 'المطبخ',
      'calories': 'السعرات الحرارية',
      'servings': 'عدد الحصص',
      'easy': 'سهل',
      'medium': 'متوسط',
      'hard': 'صعب',
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
      'recipe_details': 'Détails de la Recette',
      'recipe_prefix': 'Recette:',
      'ingredients_prefix': 'Ingrédients:',
      'instructions_prefix': 'Instructions:',
      'search_recipes_hint': 'Rechercher des recettes...',
      'no_saved_recipes': 'Aucune recette sauvegardée.',
      'contains': 'Contient:',
      'press_spin': 'Appuyez sur le bouton pour tourner!',
      'spin_button': 'Tourner la Roulette',
      'add_timer': 'Ajouter un Minuteur',
      'timer_name': 'Nom du Minuteur',
      'hours': 'Heures',
      'minutes': 'Minutes',
      'start': 'Démarrer',
      'cancel': 'Annuler',
      'breakfast': 'Petit-déjeuner',
      'lunch': 'Déjeuner',
      'dinner': 'Dîner',
      'dessert': 'Dessert',
      'cuisine': 'Cuisine',
      'difficulty': 'Difficulté',
      'cooking_time': 'Temps de Cuisson',
      'calories': 'Calories',
      'servings': 'Portions',
      'easy': 'Facile',
      'medium': 'Moyen',
      'hard': 'Difficile',
      'kitchen_tools': 'Outils de Cuisine',
      'cup_converter': 'Convertisseur de Tasses',
      'convert_from': 'Convertir de',
      'convert_to': 'Convertir en',
      'amount': 'Quantité',
      'convert': 'Convertir',
      'result': 'Résultat',
      'cups': 'Tasses',
      'milliliters': 'Millilitres',
      'fluid_ounces': 'Onces Liquides',
      'tablespoons': 'Cuillères à Soupe',
      'teaspoons': 'Cuillères à Café',
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
      'recipe_details': 'Detalles de la Receta',
      'recipe_prefix': 'Receta:',
      'ingredients_prefix': 'Ingredientes:',
      'instructions_prefix': 'Instrucciones:',
      'search_recipes_hint': 'Buscar recetas...',
      'no_saved_recipes': 'No hay recetas guardadas.',
      'contains': 'Contiene:',
      'press_spin': '¡Presiona el botón para girar!',
      'spin_button': 'Girar la Ruleta',
      'add_timer': 'Agregar Temporizador',
      'timer_name': 'Nombre del Temporizador',
      'hours': 'Horas',
      'minutes': 'Minutos',
      'start': 'Iniciar',
      'cancel': 'Cancelar',
      'breakfast': 'Desayuno',
      'lunch': 'Almuerzo',
      'dinner': 'Cena',
      'dessert': 'Postre',
      'cuisine': 'Cocina',
      'difficulty': 'Dificultad',
      'cooking_time': 'Tiempo de Cocción',
      'calories': 'Calorías',
      'servings': 'Porciones',
      'easy': 'Fácil',
      'medium': 'Medio',
      'hard': 'Difícil',
      'kitchen_tools': 'Herramientas de Cocina',
      'cup_converter': 'Convertidor de Tazas',
      'convert_from': 'Convertir de',
      'convert_to': 'Convertir a',
      'amount': 'Cantidad',
      'convert': 'Convertir',
      'result': 'Resultado',
      'cups': 'Tazas',
      'milliliters': 'Mililitros',
      'fluid_ounces': 'Onzas Líquidas',
      'tablespoons': 'Cucharadas',
      'teaspoons': 'Cucharaditas',
    }
  };

  String getTranslatedText(String key, {bool keepEnglish = false}) {
    if (keepEnglish) {
      return translations['English']![key]!;
    }
    return translations[selectedLanguage]?[key] ?? translations['English']![key]!;
  }

  Future<void> _loadRecipeImage(String recipe) async {
    if (!recipeImages.containsKey(recipe)) {
      String searchTerm = recipe;
      if (recipe == 'Classic Beef Burger') {
        searchTerm = 'burger';
      }
      final imageUrl = await UnsplashService.getRecipeImage(searchTerm);
      if (imageUrl != null) {
        setState(() {
          recipeImages[recipe] = imageUrl;
        });
      }
    }
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
      selectedTab = 7; // Update help tab index
    });
  }

  List<String> getFilteredRecipes() {
    if (selectedIngredients.isEmpty) {
      return [];
    }

    return recipeDetails.entries.where((entry) {
      // Check all filters first
      if (selectedMealType.isNotEmpty && 
          entry.value['mealType']?.toLowerCase() != selectedMealType) {
        return false;
      }

      // Check difficulty filter
      if (selectedDifficulty.isNotEmpty && 
          entry.value['difficulty'] != selectedDifficulty) {
        return false;
      }

      // Check cuisine filter
      if (selectedCuisine.isNotEmpty && 
          entry.value['cuisine'] != selectedCuisine) {
        return false;
      }

      // Check calorie range
      final calories = int.tryParse(entry.value['calories']?.split(' ')[0] ?? '0') ?? 0;
      if (selectedCalorieRange.isNotEmpty) {
        switch (selectedCalorieRange) {
          case 'under-300':
            if (calories >= 300) return false;
            break;
          case '300-600':
            if (calories < 300 || calories > 600) return false;
            break;
          case '600-900':
            if (calories < 600 || calories > 900) return false;
            break;
          case 'above-900':
            if (calories <= 900) return false;
            break;
        }
      }

      // Now check ingredients
      String ingredients = entry.value['ingredients']?.toLowerCase() ?? '';
      List<String> requiredIngredients = ingredients
          .split('\n')
          .map((line) => line.trim().replaceAll(RegExp(r'^-\s*'), ''))
          .where((line) => line.isNotEmpty && !line.contains('(optional)'))
          .toList();

      if (useMinimumIngredients) {
        Set<String> matchingIngredients = {};
        for (var ingredient in requiredIngredients) {
          List<String> alternatives = ingredient.split(RegExp(r'\s+OR\s+'));
          for (var selected in selectedIngredients) {
            if (alternatives.any((alt) => 
                alt.toLowerCase().contains(selected.toLowerCase()))) {
              matchingIngredients.add(selected);
            }
          }
        }
        return matchingIngredients.isNotEmpty;
      } else {
        for (var ingredient in requiredIngredients) {
          List<String> alternatives = ingredient.split(RegExp(r'\s+OR\s+'));
          bool hasIngredient = false;
          for (var selected in selectedIngredients) {
            if (alternatives.any((alt) => 
                alt.toLowerCase().contains(selected.toLowerCase()))) {
              hasIngredient = true;
              break;
            }
          }
          if (!hasIngredient) {
            return false;
          }
        }
        return true;
      }
    }).map((entry) => entry.key).toList();
  }

  void switchToFilteredRecipes() {
    if (selectedIngredients.isNotEmpty) {
      final filteredRecipes = getFilteredRecipes();
      
      if (filteredRecipes.isEmpty) {
        // Show message if no recipes found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No recipes found with selected ingredients'),
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        'Found ${filteredRecipes.length} matching recipes:',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];
                      final recipeIngredients = recipeDetails[recipe]?['ingredients'] ?? '';
                      
                      // Calculate matching ingredients
                      final matchingIngredients = selectedIngredients.where((ingredient) =>
                          recipeIngredients.toLowerCase().contains(ingredient.toLowerCase())).toList();
                      
                      return ListTile(
                        title: Text(
                          recipe,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${getTranslatedText('contains')} ${matchingIngredients.join(", ")}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          switchToRecipeDetails(recipe);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void switchToRecipeRoulette() {
    setState(() {
      selectedTab = 3;
      selectedRecipe = '';
    });
  }

  void switchToTimers() {
    setState(() {
      selectedTab = 4; // Timers tab
    });
  }

  void switchToSettings() {
    setState(() {
      selectedTab = 6;
    });
  }
  
  void switchToKitchenTools() {
    setState(() {
      selectedTab = 5; 
    });
  }

  void startRoulette() async {
    setState(() {
      isSpinning = true;
    });

    final random = math.Random();
    final recipes = recipeDetails.entries
        .where((entry) => 
          selectedMealType.isEmpty || 
          entry.value['mealType']?.toLowerCase() == selectedMealType)
        .map((entry) => entry.key)
        .where((recipe) => recipe != lastRecipe) // Filter out last recipe
        .toList()
      ..shuffle(random);

    if (recipes.isEmpty) {
      setState(() {
        isSpinning = false;
        selectedRecipe = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(recipes.isEmpty 
            ? 'No recipes found for selected meal type' 
            : 'Only one recipe available for this type'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    for (int i = 0; i < 20; i++) {
      await Future.delayed(Duration(milliseconds: 100 + (i * 10)), () {
        setState(() {
          selectedRecipe = recipes[random.nextInt(recipes.length)];
        });
      });
    }

    await Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        selectedRecipe = recipes[random.nextInt(recipes.length)];
        lastRecipe = selectedRecipe; // Store the selected recipe
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
  void initState() {
    super.initState();
    _ingredientsTabController = TabController(length: 2, vsync: this);
    _calorieLimitController = TextEditingController(text: calorieLimit.toString());
  }

  @override
  void dispose() {
    _ingredientsTabController.dispose();
    _calorieLimitController.dispose();
    for (final timer in activeTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }

  Widget buildMealTypeFilters() {
    final mealTypes = ['breakfast', 'lunch', 'dinner', 'dessert'];
    
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        alignment: WrapAlignment.start,
        children: mealTypes.map((type) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: FilterChip(
              label: Text(getTranslatedText(type)),
              selected: selectedMealType == type,
              onSelected: (selected) {
                setState(() {
                  selectedMealType = selected ? type : '';
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  // Change these state variables
  String selectedRecipe = '';
  int previousTab = 0;
  String? selectedDay;
  int? selectedMealSlot;

  void switchToRecipeDetails(String recipeName) {
    setState(() {
      if (selectedDay != null && selectedMealSlot != null) {
        // Coming from meal planner
        final mealList = weeklyMeals[selectedDay]!;
        while (mealList.length <= selectedMealSlot!) {
          mealList.add(''); // Fill with empty strings up to the selected slot
        }
        mealList[selectedMealSlot!] = recipeName;
        selectedDay = null;
        selectedMealSlot = null;
        selectedTab = 6; // Return to meal planner (index 6)
      } else {
        previousTab = selectedTab;
        selectedTab = 9; // Recipe details
        selectedRecipe = recipeName;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    
    return Scaffold(
      key: scaffoldKey,
      appBar: !isWide ? AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text('COOKUP', 
          style: GoogleFonts.sairaStencilOne(fontSize: 24)
        ),
      ) : null,
      drawer: !isWide ? Drawer(
        child: Column(
          children: [
            Container(
              height: 80, // Reduce header height
              padding: EdgeInsets.all(16),
              child: Text('COOKUP', 
                style: GoogleFonts.sairaStencilOne(fontSize: 32)
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                // Fix drawer menu items
                children: [
                  ListTile(
                    leading: const Icon(Icons.menu_book_outlined),
                    title: Text(getTranslatedText('recipes')),
                    selected: selectedTab == 0,
                    onTap: () {
                      setState(() => selectedTab = 0);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.egg),
                    title: Text(getTranslatedText('ingredients')),
                    selected: selectedTab == 1,
                    onTap: () {
                      setState(() => selectedTab = 1);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.offline_pin),
                    title: Text(getTranslatedText('saved_recipes')),
                    selected: selectedTab == 2,
                    onTap: () {
                      setState(() => selectedTab = 2);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.casino),
                    title: Text(getTranslatedText('recipe_roulette')),
                    selected: selectedTab == 3,
                    onTap: () {
                      setState(() => selectedTab = 3);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.timer),
                    title: Text(getTranslatedText('recipe_timers')),
                    selected: selectedTab == 4,
                    onTap: () {
                      setState(() => selectedTab = 4);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.kitchen),
                    title: Text(getTranslatedText('kitchen_tools')),
                    selected: selectedTab == 5,
                    onTap: () {
                      setState(() => selectedTab = 5);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_month),
                    title: Text('Meal Planner'),
                    selected: selectedTab == 6,
                    onTap: () {
                      setState(() => selectedTab = 6);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: Text(getTranslatedText('settings')),
                    selected: selectedTab == 7,
                    onTap: () {
                      setState(() => selectedTab = 7);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: Text(getTranslatedText('help')),
                    selected: selectedTab == 8,
                    onTap: () {
                      setState(() => selectedTab = 8);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ) : null,
      body: Row(
        children: [
          if (isWide) NavigationRail(
            extended: true,
            leading: Text('COOKUP', 
              style: GoogleFonts.sairaStencilOne(fontSize: 42)
            ),
            selectedIndex: selectedTab > 7 ? previousTab : selectedTab,
            onDestinationSelected: (index) {
              setState(() => selectedTab = index);
            },
            // Fix NavigationRail destinations
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.menu_book_outlined),
                label: Text(getTranslatedText('recipes')),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.egg),
                label: Text(getTranslatedText('ingredients')),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.offline_pin),
                label: Text(getTranslatedText('saved_recipes')),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.casino),
                label: Text(getTranslatedText('recipe_roulette')),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.timer),
                label: Text(getTranslatedText('recipe_timers')),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.kitchen),
                label: Text(getTranslatedText('kitchen_tools')),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.calendar_month),
                label: Text('Meal Planner'),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.settings),
                label: Text(getTranslatedText('settings')),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.help),
                label: Text(getTranslatedText('help')),
              ),
            ],
          ),
          Expanded(
            child: selectedTab == 9 
              ? _buildRecipeDetailsView()
              : _buildBody(selectedTab),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return _buildRecipesTab();
      case 1:
        return _buildIngredientsTab();
      case 2:
        return _buildSavedRecipesTab();
      case 3:
        return _buildRecipeRouletteTab();
      case 4:
        return _buildTimersTab();
      case 5:
        return _buildKitchenToolsTab();
      case 6:
        return _buildMealPlannerTab(); // Move meal planner here
      case 7:
        return _buildSettingsTab();
      case 8:
        return _buildHelpTab();
      case 9:
        return _buildRecipeDetailsView();
      default:
        return _buildRecipesTab();
    }
  }

  Widget _buildRecipeDetailsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  selectedTab = previousTab;
                });
              },
            ),
            Expanded(
              child: Text(
                getTranslatedText('recipe_details'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - Recipe details
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${getTranslatedText('recipe_prefix')} $selectedRecipe',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${getTranslatedText('ingredients_prefix')}\n${recipeDetails[selectedRecipe]?['ingredients'] ?? ''}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${getTranslatedText('instructions_prefix')}\n${recipeDetails[selectedRecipe]?['instructions'] ?? ''}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                // Right side - Recipe info
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(Icons.restaurant_menu, 'cuisine', 
                            recipeDetails[selectedRecipe]?['cuisine'] ?? ''),
                          const SizedBox(height: 12),
                          _buildInfoRow(Icons.accessibility, 'difficulty', 
                            recipeDetails[selectedRecipe]?['difficulty'] ?? ''),
                          const SizedBox(height: 12),
                          _buildInfoRow(Icons.timer, 'cooking_time', 
                            recipeDetails[selectedRecipe]?['cookingTime'] ?? ''),
                          const SizedBox(height: 12),
                          _buildInfoRow(Icons.local_fire_department, 'calories', 
                            recipeDetails[selectedRecipe]?['calories'] ?? ''),
                          const SizedBox(height: 12),
                          _buildInfoRow(Icons.people, 'servings', 
                            recipeDetails[selectedRecipe]?['servings'] ?? ''),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTranslatedText(label.toLowerCase()),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value.toLowerCase().startsWith('easy') || 
                value.toLowerCase().startsWith('medium') || 
                value.toLowerCase().startsWith('hard') 
                    ? getTranslatedText(value.toLowerCase())
                    : value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecipesTab() {
    return Column(
      children: [
        if (selectedDay != null) 
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Select ${selectedMealSlot == 0 ? "breakfast" : 
                             selectedMealSlot == 1 ? "lunch" : "dinner"} for $selectedDay',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedDay = null;
                      selectedMealSlot = null;
                      selectedTab = 8; // Go back to planner
                    });
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
            decoration: InputDecoration(
              hintText: getTranslatedText('search_recipes_hint'),
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
            ),
          ),
        ),
        buildMealTypeFilters(),
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
                .map((recipe) => _buildRecipeCard(recipe))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeCard(String recipe) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    _loadRecipeImage(recipe);
    
    return Card(
      child: InkWell(
        onTap: () => switchToRecipeDetails(recipe),
        child: Stack(
          children: [
            if (recipeImages.containsKey(recipe))
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Image.network(
                        recipeImages[recipe]!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CircularProgressIndicator());
                        },
                      ),
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                          child: Container(
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (!recipeImages.containsKey(recipe))
              Positioned.fill(
                child: Center(
                  child: Icon(
                    Icons.menu_book,
                    color: isSmallScreen ? Theme.of(context).disabledColor : null,
                    size: 50,
                  ),
                ),
              ),
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Theme.of(context).cardColor.withOpacity(0.8),
                child: Text(
                  recipe,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsTab() {
    return Column(
      children: [
        TabBar(
          controller: _ingredientsTabController,
          tabs: [
            Tab(text: 'Ingredients'),
            Tab(text: 'Filters'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _ingredientsTabController,
            children: [
              _buildIngredientsView(),
              _buildFiltersView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsView() {
    final allIngredients = [
      // Basic ingredients
      'Eggs', 'Milk', 'Butter', 'Salt', 'Pepper', 'Sugar',
      // Baking ingredients 
      'Flour', 'Baking Soda', 'Vanilla Extract', 'Chocolate', 'Cocoa Powder',
      // Oils and fats
      'Olive Oil', 'Oil',
      // Proteins
      'Ground Beef', 'Steak', 'Chicken Breast', 'Chicken Drums',
      // Produce
      'Potatoes', 'Garlic', 'Onion', 'Tomatoes', 'Lettuce',
      // Dairy and others
      'Cheese', 'Cream', 'Rice', 'Pasta', 'Bread'
    ];

    // Filter ingredients based on all selected filters
    List<String> filteredIngredients = selectedMealType.isEmpty
        ? allIngredients
        : allIngredients.where((ingredient) {
            return recipeDetails.entries.any((recipe) {
              final matchesMealType = selectedMealType.isEmpty || 
                  recipe.value['mealType']?.toLowerCase() == selectedMealType;
              final matchesDifficulty = selectedDifficulty.isEmpty || 
                  recipe.value['difficulty']?.toLowerCase() == selectedDifficulty.toLowerCase();
              final matchesCuisine = selectedCuisine.isEmpty || 
                  recipe.value['cuisine'] == selectedCuisine;
              
              // Parse cooking time
              final cookingTime = recipe.value['cookingTime']?.toLowerCase() ?? '';
              final minutes = int.tryParse(cookingTime.split(' ')[0]) ?? 0;
              final matchesTime = selectedTimeRange.isEmpty || 
                  (selectedTimeRange == 'Quick (< 15min)' && minutes < 15) ||
                  (selectedTimeRange == 'Medium (15-30min)' && minutes >= 15 && minutes <= 30) ||
                  (selectedTimeRange == 'Long (> 30min)' && minutes > 30);

              // Parse calories
              final calories = int.tryParse(
                  recipe.value['calories']?.split(' ')[0] ?? '0') ?? 0;
              final matchesCalories = selectedCalorieRange.isEmpty ||
                  (selectedCalorieRange == '0-200' && calories <= 200) ||
                  (selectedCalorieRange == '201-400' && calories > 200 && calories <= 400) ||
                  (selectedCalorieRange == '401+' && calories > 400);

              return matchesMealType && matchesDifficulty && 
                     matchesCuisine && matchesTime && matchesCalories &&
                     recipe.value['ingredients']?.toLowerCase().contains(ingredient.toLowerCase()) == true;
            });
          }).toList();

    return Column(
      children: [
        buildMealTypeFilters(),
        // Existing ingredients selection area
        Container(
          constraints: BoxConstraints(
            minHeight: 100,
            maxHeight: 100 + (selectedIngredients.length > 4 ? 50 : 0),
          ),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 2,
            ),
          ),
          child: Center(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: selectedIngredients
                  .map((ingredient) => _buildIngredientChip(ingredient))
                  .toList(),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: selectedIngredients.isEmpty ? null : switchToFilteredRecipes,
          child: Text(getTranslatedText('search_for_recipes')),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            padding: const EdgeInsets.all(20),
            children: filteredIngredients
                .map((ingredient) => _buildIngredientCard(ingredient))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientChip(String ingredient) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIngredients.remove(ingredient);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 2,
          ),
        ),
        child: Text(
          ingredient,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientCard(String ingredient) {
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
      child: Card(
        child: Center(
          child: Text(
            ingredient,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildSavedRecipesTab() {
    return savedRecipes.isEmpty
      ? Center(
          child: Text(
            getTranslatedText('no_saved_recipes'),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
              child: ListTile(
                title: Text(
                  recipe,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
        );
  }

  Widget _buildRecipeRouletteTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildMealTypeFilters(),
        const SizedBox(height: 10),
        Expanded(
          child: Center(
            child: isSpinning
              ? Text(
                  selectedRecipe,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: selectedRecipe.isNotEmpty
                          ? () {
                              switchToRecipeDetails(selectedRecipe);
                            }
                          : null,
                      child: Text(
                        selectedRecipe.isNotEmpty
                            ? selectedRecipe
                            : getTranslatedText('press_spin'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: startRoulette,
                      icon: const Icon(Icons.casino),
                      label: Text(getTranslatedText('spin_button')),
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
    );
  }

  Widget _buildTimersTab() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            getTranslatedText('recipe_timers'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                Card(
                  child: ListTile(
                    title: Text(getTranslatedText('add_timer')),
                    leading: const Icon(Icons.add),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          String name = '';
                          bool showError = false;
                          final ValueNotifier<int> hours = ValueNotifier(0);
                          final ValueNotifier<int> minutes = ValueNotifier(0);
                          
                          return StatefulBuilder(
                            builder: (context, setDialogState) {
                              return AlertDialog(
                                title: Text(getTranslatedText('add_timer')),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: getTranslatedText('timer_name'),
                                        errorText: showError ? 'Name required' : null,
                                      ),
                                      onChanged: (value) {
                                        name = value;
                                        if (showError) {
                                          setDialogState(() {
                                            showError = false;
                                          });
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Text(getTranslatedText('hours')),
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
                                            Text(getTranslatedText('minutes')),
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
                                                      if (minutes.value < 59) {
                                                        minutes.value++;
                                                      } else {
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
                                    child: Text(getTranslatedText('cancel')),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (name.isEmpty) {
                                        setDialogState(() {
                                          showError = true;
                                        });
                                        return;
                                      }
                                      if (hours.value > 0 || minutes.value > 0) {
                                        startTimer(name, (hours.value * 3600) + (minutes.value * 60));
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text(getTranslatedText('start')),
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
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTranslatedText('settings'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: widget.isDarkMode,
                onChanged: widget.onThemeChanged ,
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
          Card(
            child: ListTile(
              title: const Text('Minimum Ingredients Mode'),
              subtitle: const Text('Show recipes containing any selected ingredient'),
              trailing: Switch(
                value: useMinimumIngredients,
                onChanged: (value) {
                  setState(() {
                    useMinimumIngredients = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What Each Room Does',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                'Ingredient Room\n'
                'Select the ingredients you currently have. By default, it will show recipes where you have all required ingredients. You can change this in settings with "Minimum Ingredients Mode".\n\n'
                'Recipe Room\n'
                'Browse all available recipes. Use meal type filters to narrow down your search. Click any recipe to see details.\n\n'
                'Saved Recipe Room\n'
                'Save your favorite recipes so you can find them easily later. Click the heart icon in recipe details to save.\n\n'
                'Recipe Roulette\n'
                'Let the app randomly select a recipe for you. Use meal type filters to narrow down choices. It won\'t repeat the last selected recipe.\n\n'
                'Recipe Timers\n'
                'Set multiple timers for different steps of your cooking process. Name each timer to keep track.\n\n'
                'Kitchen Tools\n'
                'Helpful cooking utilities like the cup converter for quick measurement conversions.\n\n'
                'Settings\n'
                '• Dark Mode: Switch between light and dark themes\n'
                '• Language: Choose your preferred language\n'
                '• Minimum Ingredients Mode: When on, shows recipes containing any selected ingredient. When off, only shows recipes where you have all ingredients.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKitchenToolsTab() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: getTranslatedText('cup_converter')),
              Tab(text: 'Temperature'),
              Tab(text: 'Weight'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildCupConverter(),
                _buildTemperatureConverter(),
                _buildWeightConverter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCupConverter() {
    final units = ['cups', 'milliliters', 'fluid_ounces', 'tablespoons', 'teaspoons'];
    String fromUnit = 'cups';
    String toUnit = 'milliliters';
    double amount = 1.0;
    String result = '';

    final conversions = {
      'cups': {
        'milliliters': 236.588,
        'fluid_ounces': 8,
        'tablespoons': 16,
        'teaspoons': 48,
      },
      'milliliters': {
        'cups': 0.00422675,
        'fluid_ounces': 0.033814,
        'tablespoons': 0.067628,
        'teaspoons': 0.202884,
      },
      'fluid_ounces': {
        'cups': 0.125,
        'milliliters': 29.5735,
        'tablespoons': 2,
        'teaspoons': 6,
      },
      'tablespoons': {
        'cups': 0.0625,
        'milliliters': 14.7868,
        'fluid_ounces': 0.5,
        'teaspoons': 3,
      },
      'teaspoons': {
        'cups': 0.0208333,
        'milliliters': 4.92892,
        'fluid_ounces': 0.166667,
        'tablespoons': 0.333333,
      },
    };

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: fromUnit,
                        decoration: InputDecoration(
                          labelText: getTranslatedText('convert_from'),
                        ),
                        items: units.map((unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(getTranslatedText(unit)),
                        )).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => fromUnit = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          labelText: getTranslatedText('amount'),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() => amount = double.tryParse(value) ?? 0);
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: toUnit,
                        decoration: InputDecoration(
                          labelText: getTranslatedText('convert_to'),
                        ),
                        items: units.map((unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(getTranslatedText(unit)),
                        )).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => toUnit = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (fromUnit == toUnit) {
                            setState(() => result = amount.toString());
                          } else {
                            final conversion = conversions[fromUnit]?[toUnit] ?? 0;
                            setState(() => result = (amount * conversion).toStringAsFixed(2));
                          }
                        },
                        child: Text(getTranslatedText('convert')),
                      ),
                      if (result.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          '${getTranslatedText('result')}: $result ${getTranslatedText(toUnit)}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTemperatureConverter() {
    double celsius = 0;
    double fahrenheit = 0;
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Celsius',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          celsius = double.tryParse(value) ?? 0;
                          setState(() {
                            fahrenheit = (celsius * 9/5) + 32;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Fahrenheit: ${fahrenheit.toStringAsFixed(1)}°F',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeightConverter() {
    double grams = 0;
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Grams',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          grams = double.tryParse(value) ?? 0;
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Ounces: ${(grams / 28.35).toStringAsFixed(2)} oz',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pounds: ${(grams / 453.6).toStringAsFixed(2)} lb',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFiltersView() {
    final difficulties = ['Easy', 'Medium', 'Hard'];
    final cuisines = ['American', 'Italian', 'Asian', 'International', 'Asian Fusion'];
    final timeRanges = ['Quick (< 15min)', 'Medium (15-30min)', 'Long (> 30min)'];

    // Calculate total calories of selected recipes
    if (selectedIngredients.isNotEmpty) {
      final recipes = getFilteredRecipes();
      for (var recipe in recipes) {
        final calories = int.tryParse(
          recipeDetails[recipe]?['calories']?.split(' ')[0] ?? '0') ?? 0;
      }
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildFilterSection('Difficulty', difficulties, selectedDifficulty, 
          (val) => setState(() => selectedDifficulty = val)),
        _buildFilterSection('Cuisine', cuisines, selectedCuisine, 
          (val) => setState(() => selectedCuisine = val)),
        _buildFilterSection('Cooking Time', timeRanges, selectedTimeRange, 
          (val) => setState(() => selectedTimeRange = val)),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Calorie Range', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children: [
                    FilterChip(
                      label: const Text('Under 300'),
                      selected: selectedCalorieRange == 'under-300',
                      onSelected: (selected) {
                        setState(() {
                          selectedCalorieRange = selected ? 'under-300' : '';
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('300-600'),
                      selected: selectedCalorieRange == '300-600',
                      onSelected: (selected) {
                        setState(() {
                          selectedCalorieRange = selected ? '300-600' : '';
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('600-900'),
                      selected: selectedCalorieRange == '600-900',
                      onSelected: (selected) {
                        setState(() {
                          selectedCalorieRange = selected ? '600-900' : '';
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('Above 900'),
                      selected: selectedCalorieRange == 'above-900',
                      onSelected: (selected) {
                        setState(() {
                          selectedCalorieRange = selected ? 'above-900' : '';
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (selectedDifficulty.isNotEmpty || selectedCuisine.isNotEmpty || 
            selectedTimeRange.isNotEmpty || calorieLimit != 2000)
          ElevatedButton(
            onPressed: () => setState(() {
              selectedDifficulty = '';
              selectedCuisine = '';
              selectedTimeRange = '';
              calorieLimit = 2000;
            }),
            child: const Text('Clear All Filters'),
          ),
      ],
    );
  }

  Widget _buildFilterSection(String title, List<String> options, String selected, Function(String) onChanged) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Wrap(
              spacing: 8.0,
              children: options.map((option) => FilterChip(
                label: Text(option),
                selected: selected == option,
                onSelected: (bool selected) {
                  onChanged(selected ? option : '');
                },
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealPlannerTab() {
    return Column(
      children: [
        Container(
          height: 100,
          margin: const EdgeInsets.all(16),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: weeklyMeals.entries.map((day) {
              bool isSelected = selectedDay == day.key;
              return Container(
                width: 100,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Card(
                  elevation: isSelected ? 8 : 1,
                  color: isSelected ? Theme.of(context).primaryColor : null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day.key,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${day.value.length}/3 meals',
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white70 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: weeklyMeals.length,
            itemBuilder: (context, dayIndex) {
              final day = weeklyMeals.entries.elementAt(dayIndex);
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        day.key,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (context, mealIndex) {
                        final String mealType = mealIndex == 0 ? 'Breakfast' :
                                             mealIndex == 1 ? 'Lunch' : 'Dinner';
                        final String? recipe = day.value.length > mealIndex ? 
                                            day.value[mealIndex] : null;
                        
                        return ListTile(
                          leading: Icon(
                            mealIndex == 0 ? Icons.breakfast_dining :
                            mealIndex == 1 ? Icons.lunch_dining :
                                           Icons.dinner_dining
                          ),
                          title: Text(mealType),
                          subtitle: Text(recipe?.isNotEmpty == true ? recipe! : 'Tap to add meal'),
                          trailing: recipe?.isNotEmpty == true ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                day.value.removeAt(mealIndex);
                              });
                            },
                          ) : null,
                          onTap: () {
                            setState(() {
                              selectedDay = day.key;
                              selectedMealSlot = mealIndex;
                              selectedTab = 0; // Go to recipes
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Add this near the top of the file, after the imports
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
