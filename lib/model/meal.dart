class Meal {
  final String mealTime;
  final String name;
  final String imagePath;
  final String kiloCaloriesBurnt;
  final String timeTaken;
  final String preparation;
  final List<String> ingredients;

  Meal({
    required this.mealTime,
    required this.name,
    required this.imagePath,
    required this.kiloCaloriesBurnt,
    required this.timeTaken,
    this.preparation = 'Preparation information will be added soon.',
    this.ingredients = const [],
  });
}

final meals = [
  Meal(
    mealTime: "BREAKFAST PROTEIN",
    name: "Fruit Granola",
    kiloCaloriesBurnt: "271",
    timeTaken: "10",
    imagePath: "assets/fruit_granola.jpg",
    ingredients: [
      "1 cup of granola",
      "1 banana",
      "1/2 cup of raisins",
      "1 tbsp of honey",
    ],
    preparation: "Mix granola, banana, raisins and honey. Serve fresh.",
  ),
  Meal(
    mealTime: "DINNER DIET",
    name: "Pesto Pasta",
    kiloCaloriesBurnt: "612",
    timeTaken: "15",
    imagePath: "assets/pesto_pasta.jpg",
    ingredients: [
      "150g pasta",
      "2 tbsp pesto sauce",
      "Cherry tomatoes",
      "Parmesan cheese",
    ],
    preparation: "Boil pasta, add pesto sauce, tomatoes and parmesan.",
  ),
  Meal(
    mealTime: "SNACK PROTEIN",
    name: "Keto Snack",
    kiloCaloriesBurnt: "414",
    timeTaken: "16",
    imagePath: "assets/keto_snack.jpg",
    ingredients: [
      "2 boiled eggs",
      "Avocado",
      "Cheese",
      "Nuts",
    ],
    preparation: "Slice all ingredients and serve as a healthy keto snack.",
  ),
  Meal(
    mealTime: "BREAKFAST DIET",
    name: "Oatmeal with Berries",
    kiloCaloriesBurnt: "320",
    timeTaken: "12",
    imagePath: "assets/oatmeal_with_berries.jpg",
    ingredients: [
      "Oats",
      "Milk",
      "Blueberries",
      "Honey",
    ],
    preparation: "Cook oats with milk, add berries and honey.",
  ),
  Meal(
    mealTime: "LUNCH PROTEIN",
    name: "Chicken Rice Bowl",
    kiloCaloriesBurnt: "540",
    timeTaken: "25",
    imagePath: "assets/chicken_rice_bowl.jpg",
    ingredients: [
      "Chicken breast",
      "Rice",
      "Cucumber",
      "Tomato",
    ],
    preparation: "Cook rice, grill chicken and serve with vegetables.",
  ),
  Meal(
    mealTime: "DINNER PROTEIN",
    name: "Grilled Salmon",
    kiloCaloriesBurnt: "480",
    timeTaken: "20",
    imagePath: "assets/grilled_salmon.jpg",
    ingredients: [
      "Salmon fillet",
      "Lemon",
      "Olive oil",
      "Green salad",
    ],
    preparation: "Grill salmon with lemon and serve with salad.",
  ),
  Meal(
    mealTime: "LUNCH DIET",
    name: "Vegetable Salad",
    kiloCaloriesBurnt: "210",
    timeTaken: "8",
    imagePath: "assets/vegetable_salad.jpg",
    ingredients: [
      "Lettuce",
      "Cucumber",
      "Tomato",
      "Olive oil",
    ],
    preparation: "Chop vegetables, add olive oil and mix.",
  ),
  Meal(
    mealTime: "SNACK DIET",
    name: "Greek Yogurt",
    kiloCaloriesBurnt: "180",
    timeTaken: "5",
    imagePath: "assets/greek _yogurt.jpg",
    ingredients: [
      "Greek yogurt",
      "Honey",
      "Nuts",
      "Berries",
    ],
    preparation: "Add honey, nuts and berries to yogurt.",
  ),
  Meal(
    mealTime: "BREAKFAST PROTEIN",
    name: "Egg Toast",
    kiloCaloriesBurnt: "350",
    timeTaken: "10",
    imagePath: "assets/egg_toast.jpg",
    ingredients: [
      "Whole grain bread",
      "Eggs",
      "Avocado",
      "Salt",
    ],
    preparation: "Toast bread, cook eggs and add avocado.",
  ),
  Meal(
    mealTime: "DINNER DIET",
    name: "Turkey with Vegetables",
    kiloCaloriesBurnt: "430",
    timeTaken: "22",
    imagePath: "assets/turkey_with_vegetables.jpg",
    ingredients: [
      "Turkey fillet",
      "Broccoli",
      "Carrot",
      "Olive oil",
    ],
    preparation: "Cook turkey and vegetables in a pan.",
  ),
];
