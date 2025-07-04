Map<String, Map<String, dynamic>> recipeDetails = {
    'Eggs': {
      'ingredients': '- 2 Eggs\n- Salt\n- Butter OR Olive Oil\n- Pepper (optional)',
      'mealType': 'breakfast',
      'cuisine': 'International',
      'difficulty': 'Easy',
      'cookingTime': '10 minutes',
      'calories': '150 per serving',
      'servings': '1',
      'instructions': '1. Heat a pan over medium heat.\n'
          '2. Add butter to the pan.\n'
          '3. Crack the eggs into the pan.\n'
          '4. Sprinkle salt and pepper.\n'
          '5. Cook until desired doneness.',
    },
    'Mashed Potatoes': {
      'ingredients': '- 4 Potatoes\n- Butter OR Olive Oil\n- Milk OR Cream\n- Salt\n- Pepper (optional)\n- Cheese (optional)',
      'mealType': 'dinner',
      'cuisine': 'American',
      'difficulty': 'Easy',
      'cookingTime': '30 minutes',
      'calories': '210 per serving',
      'servings': '4',
      'instructions': '1. Peel and boil the potatoes until soft.\n'
          '2. Mash the potatoes.\n'
          '3. Add butter, milk, salt, and pepper.\n'
          '4. Mix until smooth.',
    },
    'Steak': {
      'ingredients': '- 1 Steak\n- Salt\n- Pepper (optional)\n- Olive Oil\n- Garlic (optional)',
      'mealType': 'dinner',
      'cuisine': 'American',
      'difficulty': 'Medium',
      'cookingTime': '15 minutes',
      'calories': '350 per serving',
      'servings': '1',
      'instructions': '1. Season the steak with salt and pepper.\n'
          '2. Heat olive oil in a pan over high heat.\n'
          '3. Cook the steak to your desired doneness.\n'
          '4. Let it rest before serving.',
    },
    'Grilled Cheese': {
      'ingredients': '- 2 Slices of Bread\n- Butter\n- 2 Slices of Cheese\n- Garlic Powder (optional)',
      'mealType': 'lunch',
      'cuisine': 'International',
      'difficulty': 'Easy',
      'cookingTime': '10 minutes',
      'calories': '300 per serving',
      'servings': '1',
      'instructions': '1. Butter one side of each slice of bread.\n'
          '2. Place cheese between the unbuttered sides.\n'
          '3. Grill in a pan until golden brown on both sides.',
    },
    'Boiled Eggs': {
      'ingredients': '- 2 Eggs\n- Water\n- Salt',
      'mealType': 'breakfast',
      'cuisine': 'International',
      'difficulty': 'Easy',
      'cookingTime': '10 minutes',
      'calories': '140 per serving',
      'servings': '1',
      'instructions': '1. Place eggs in a pot and cover with water.\n'
          '2. Bring to a boil and cook for 6-10 minutes.\n'
          '3. Cool in ice water before peeling.',
    },
    'Chicken': {
      'ingredients': '- 1 Chicken Breast\n- Salt\n- Pepper\n- Olive Oil',
      'mealType': 'dinner',
      'cuisine': 'International',
      'difficulty': 'Medium',
      'cookingTime': '25 minutes',
      'calories': '250 per serving',
      'servings': '1',
      'instructions': '1. Season the chicken with salt and pepper.\n'
          '2. Heat olive oil in a pan over medium heat.\n'
          '3. Cook the chicken until fully cooked.\n'
          '4. Let it rest before serving.',
    },
    'Pancakes': {
      'ingredients': '- 1 Cup Flour\n- 1 Cup Milk\n- 1 Egg\n- 2 Tbsp Sugar\n- 1 Tsp Baking Powder\n- Butter',
      'mealType': 'breakfast',
      'cuisine': 'American',
      'difficulty': 'Easy',
      'cookingTime': '20 minutes',
      'calories': '200 per serving',
      'servings': '4',
      'instructions': '1. Mix flour, sugar, and baking powder in a bowl.\n'
          '2. Add milk and egg, and whisk until smooth.\n'
          '3. Heat a pan and add butter.\n'
          '4. Pour batter into the pan and cook until bubbles form.\n'
          '5. Flip and cook until golden brown.',
    },
    'Brownies': {
      'ingredients': '- 1/2 Cup Butter\n- 1 Cup Sugar\n- 2 Eggs\n- 1/3 Cup Cocoa Powder\n- 1/2 Cup Flour\n- 1 Tsp Vanilla Extract',
      'mealType': 'dessert',
      'cuisine': 'American',
      'difficulty': 'Medium',
      'cookingTime': '30 minutes',
      'calories': '400 per serving',
      'servings': '8',
      'instructions': '1. Melt butter and mix with sugar.\n'
          '2. Add eggs and vanilla extract, and whisk.\n'
          '3. Stir in cocoa powder and flour.\n'
          '4. Pour batter into a greased pan.\n'
          '5. Bake at 350°F (175°C) for 20-25 minutes.',
    },
    'Apple Pie': {
      'ingredients': '- 2 Apples\n- 1/2 Cup Sugar\n- 1 Tsp Cinnamon\n- 1 Pie Crust\n- Butter',
      'mealType': 'dessert',
      'cuisine': 'American',
      'difficulty': 'Medium',
      'cookingTime': '1 hour',
      'calories': '300 per serving',
      'servings': '6',
      'instructions': '1. Slice apples and mix with sugar and cinnamon.\n'
          '2. Place the mixture in a pie crust.\n'
          '3. Dot with butter and cover with another crust.\n'
          '4. Bake at 375°F (190°C) for 40 minutes.\n'
          '5. Serve warm.',
    },
    'Chocolate Chip Cookies': {
      'ingredients': '- 1/2 Cup Butter\n- 1/2 Cup Sugar\n- 1/2 Cup Brown Sugar\n- 1 Egg\n- 1 Tsp Vanilla Extract\n- 1 1/4 Cups Flour\n- 1/2 Tsp Baking Soda\n- 1 Cup Chocolate Chips',
      'mealType': 'dessert',
      'cuisine': 'American',
      'difficulty': 'Easy',
      'cookingTime': '15 minutes',
      'calories': '150 per cookie',
      'servings': '24',
      'instructions': '1. Cream butter, sugar, and brown sugar together.\n'
          '2. Add egg and vanilla extract, and mix well.\n'
          '3. Stir in flour and baking soda.\n'
          '4. Fold in chocolate chips.\n'
          '5. Drop spoonfuls onto a baking sheet and bake at 350°F (175°C) for 10-12 minutes.',
    },
    'Caesar Salad': {
      'mealType': 'lunch',
      'cuisine': 'Italian',
      'difficulty': 'Easy',
      'cookingTime': '15 minutes',
      'calories': '180 per serving',
      'servings': '2',
      'ingredients': '''
- Lettuce
- Garlic
- Bread
- Oil
- Salt
- Pepper
- Chicken
- Tomatoes''',
      'instructions': '''
1. Wash and chop the lettuce
2. Cut bread into cubes and toast with oil and garlic for croutons
3. Grill chicken and slice
4. Mix lettuce with salt, pepper, and dressing
5. Add croutons, chicken, and tomatoes
6. Serve immediately''',
    },

    'Garden Salad': {
      'mealType': 'lunch',
      'cuisine': 'International',
      'difficulty': 'Easy',
      'cookingTime': '10 minutes',
      'calories': '120 per serving',
      'servings': '2',
      'ingredients': '''
- Lettuce
- Tomatoes
- Onion
- Salt
- Pepper
- Oil''',
      'instructions': '''
1. Wash and chop all vegetables
2. Combine in a large bowl
3. Season with salt and pepper
4. Drizzle with oil
5. Toss well and serve''',
    },

    'Garlic Beef Rice': {
      'mealType': 'dinner',
      'cuisine': 'Asian',
      'difficulty': 'Medium',
      'cookingTime': '40 minutes',
      'calories': '350 per serving',
      'servings': '4',
      'ingredients': '''
- Rice
- Beef
- Garlic
- Onion
- Oil
- Salt
- Pepper''',
      'instructions': '''
1. Cook rice according to package instructions
2. Mince garlic and dice onions
3. Heat oil in a large pan
4. Cook beef with garlic and onions until browned
5. Season with salt and pepper
6. Mix with cooked rice and serve hot''',
    },

    'Creamy Tomato Pasta': {
      'mealType': 'dinner',
      'cuisine': 'Italian',
      'difficulty': 'Easy',
      'cookingTime': '25 minutes',
      'calories': '400 per serving',
      'servings': '4',
      'ingredients': '''
- Pasta
- Tomatoes
- Garlic
- Cream
- Oil
- Salt
- Pepper
- Cheese''',
      'instructions': '''
1. Cook pasta until al dente
2. Heat oil and sauté minced garlic
3. Add chopped tomatoes and cook until soft
4. Stir in cream and simmer
5. Season with salt and pepper
6. Add cheese and stir until melted
7. Mix with pasta and serve''',
    },

    'Classic Beef Burger': {
      'mealType': 'dinner',
      'cuisine': 'American',
      'difficulty': 'Easy',
      'cookingTime': '20 minutes',
      'calories': '450 per serving',
      'servings': '1',
      'ingredients': '''
- Ground Beef
- Bread Buns
- Onion
- Lettuce
- Tomatoes
- Salt
- Pepper
- Oil''',
      'instructions': '''
1. Form the ground beef into patties
2. Season with salt and pepper
3. Heat oil in a pan
4. Cook patties 4-5 minutes each side
5. Toast the buns lightly
6. Assemble burger with lettuce, tomato, and onion
7. Serve hot''',
    },
    'Spicy Chicken Drums': {
      'ingredients': '- 8 chicken drumsticks\n- 2 tablespoons olive oil\n- 3 cloves garlic, minced\n- 1 teaspoon paprika\n- 1 teaspoon black pepper (optional)\n- 1 teaspoon salt\n- 1/2 teaspoon chili powder (optional)',
      'instructions': '1. Preheat oven to 400°F (200°C)\n2. Mix olive oil, garlic, and all spices in a bowl\n3. Coat chicken drums evenly with the spice mixture\n4. Place on a baking sheet\n5. Bake for 35-40 minutes, turning halfway\n6. Check internal temperature reaches 165°F (74°C)',
      'cuisine': 'American',
      'difficulty': 'easy',
      'cookingTime': '45 minutes',
      'calories': '280 per serving',
      'servings': '4',
      'mealType': 'dinner'
    },

    'Honey Garlic Drums': {
      'ingredients': '- 8 chicken drumsticks\n- 4 tablespoons honey\n- 4 cloves garlic, minced\n- 2 tablespoons soy sauce\n- 1 tablespoon olive oil\n- 1 teaspoon black pepper (optional)\n- 1 teaspoon salt',
      'instructions': '1. Mix honey, garlic, soy sauce, and seasonings\n2. Coat chicken drums in the mixture\n3. Heat oil in large pan over medium heat\n4. Cook drums for 20-25 minutes, turning occasionally\n5. Brush with remaining sauce while cooking\n6. Ensure internal temperature reaches 165°F (74°C)',
      'cuisine': 'Asian Fusion',
      'difficulty': 'easy',
      'cookingTime': '30 minutes',
      'calories': '310 per serving',
      'servings': '4',
      'mealType': 'dinner'
    },
  };