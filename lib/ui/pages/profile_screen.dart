import 'package:shared_preferences/shared_preferences.dart';
import 'package:darynfit/ui/pages/workout_detail_screen.dart';
import 'package:darynfit/model/upper_body_workout.dart';
import 'package:animations/animations.dart';
import 'package:darynfit/model/meal.dart';
import 'package:darynfit/ui/pages/meal_detail_screen.dart';
import 'package:darynfit/ui/pages/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' as math;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const Color bgColor = Color(0xFFE9E9E9);
  static const Color mainColor = Color(0xFF200087);
  static const Color secondColor = Color(0xFF5B4D9D);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedIndex = 0;

  int waterMl = 0;

  @override
  void initState() {
    super.initState();
    loadWater();
  }

  Future<void> loadWater() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      waterMl = prefs.getInt('waterMl') ?? 0;
    });
  }

  Future<void> saveWater() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('waterMl', waterMl);
  }

  void addWater() {
    setState(() {
      if (waterMl < 2000) {
        waterMl += 250;
      }
    });
    saveWater();
  }

  void resetWater() {
    setState(() {
      waterMl = 0;
    });
    saveWater();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final today = DateTime.now();

    return Scaffold(
      backgroundColor: ProfileScreen.bgColor,
      bottomNavigationBar: _BottomBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _HeaderSection(width: width, today: today),
                  const SizedBox(height: 24),
                  _MealsSection(),
                  const SizedBox(height: 24),
                  _WaterTrackerCard(
                    waterMl: waterMl,
                    onAdd: addWater,
                    onReset: resetWater,
                  ),
                  const SizedBox(height: 24),
                  _WorkoutCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          const _SearchPage(),
          const _UserProfilePage(),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final double width;
  final DateTime today;

  const _HeaderSection({
    required this.width,
    required this.today,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(36),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              '${DateFormat('EEEE').format(today)}, ${DateFormat('d MMMM').format(today)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            subtitle: const Text(
              'Hello, Daryn',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            trailing: ClipOval(
              child: Image.asset(
                'assets/user.jpeg',
                width: 52,
                height: 52,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _RadialProgress(
                width: width * 0.34,
                height: width * 0.34,
                progress: 0.7,
              ),
              const SizedBox(width: 18),
              const Expanded(
                child: Column(
                  children: [
                    _IngredientProgress(
                      ingredient: 'Protein',
                      progress: 0.3,
                      progressColor: Colors.green,
                      leftAmount: 72,
                    ),
                    SizedBox(height: 14),
                    _IngredientProgress(
                      ingredient: 'Carbs',
                      progress: 0.2,
                      progressColor: Colors.red,
                      leftAmount: 252,
                    ),
                    SizedBox(height: 14),
                    _IngredientProgress(
                      ingredient: 'Fat',
                      progress: 0.1,
                      progressColor: Colors.yellow,
                      leftAmount: 61,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MealsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'MEALS FOR TODAY',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 255,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: meals.length,
            separatorBuilder: (_, __) => const SizedBox(width: 18),
            itemBuilder: (context, index) {
              return _MealCard(meal: meals[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0,
      closedColor: ProfileScreen.bgColor,
      openColor: Colors.white,
      transitionType: ContainerTransitionType.fade,
      transitionDuration: const Duration(milliseconds: 700),
      openBuilder: (context, _) => WorkoutScreen(),
      closedBuilder: (context, openContainer) {
        return GestureDetector(
          onTap: openContainer,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF20008B),
                  Color(0xFF200087),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YOUR NEXT WORKOUT',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Upper Body',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 22),
                const Row(
                  children: [
                    _WorkoutIcon(asset: 'assets/chest.png'),
                    SizedBox(width: 12),
                    _WorkoutIcon(asset: 'assets/back.png'),
                    SizedBox(width: 12),
                    _WorkoutIcon(asset: 'assets/biceps.png'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SearchPage extends StatefulWidget {
  const _SearchPage();

  @override
  State<_SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<_SearchPage> {
  final TextEditingController searchController = TextEditingController();
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Meals',
    'Workout',
    'Breakfast',
    'Protein',
    'Diet',
    'Chest',
    'Back',
    'Arms',
  ];

  late final List<UpperBodyWorkout> workouts = [
    ...upperBody.expand((group) => group),
    UpperBodyWorkout(
      imagePath: 'assets/biceps.png',
      name: 'Biceps Curl',
      instruction: '3 sets - 12 repetitions',
    ),
    UpperBodyWorkout(
      imagePath: 'assets/biceps.png',
      name: 'Hammer Curl',
      instruction: '3 sets - 10 repetitions',
    ),
    UpperBodyWorkout(
      imagePath: 'assets/chest.png',
      name: 'Push Ups',
      instruction: '4 sets - 15 repetitions',
    ),
    UpperBodyWorkout(
      imagePath: 'assets/back.png',
      name: 'Seated Row',
      instruction: '3 sets - 12 repetitions',
    ),
  ];

  List<Meal> get filteredMeals {
    final query = searchController.text.toLowerCase();

    return meals.where((meal) {
      final text =
      '${meal.name} ${meal.mealTime} ${meal.kiloCaloriesBurnt} ${meal.timeTaken}'
          .toLowerCase();

      final matchesSearch = query.isEmpty || text.contains(query);

      final matchesCategory = selectedCategory == 'All' ||
          selectedCategory == 'Meals' ||
          text.contains(selectedCategory.toLowerCase());

      if (selectedCategory == 'Workout' ||
          selectedCategory == 'Chest' ||
          selectedCategory == 'Back' ||
          selectedCategory == 'Arms') {
        return false;
      }

      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<UpperBodyWorkout> get filteredWorkouts {
    final query = searchController.text.toLowerCase();

    return workouts.where((workout) {
      final text = '${workout.name} ${workout.instruction}'.toLowerCase();

      final matchesSearch = query.isEmpty || text.contains(query);

      final matchesCategory = selectedCategory == 'All' ||
          selectedCategory == 'Workout' ||
          text.contains(selectedCategory.toLowerCase()) ||
          _matchesWorkoutCategory(workout);

      if (selectedCategory == 'Meals' ||
          selectedCategory == 'Breakfast' ||
          selectedCategory == 'Protein' ||
          selectedCategory == 'Diet') {
        return false;
      }

      return matchesSearch && matchesCategory;
    }).toList();
  }

  bool _matchesWorkoutCategory(UpperBodyWorkout workout) {
    final name = workout.name.toLowerCase();
    final image = workout.imagePath.toLowerCase();

    if (selectedCategory == 'Chest') {
      return image.contains('chest') ||
          name.contains('bench') ||
          name.contains('push') ||
          name.contains('dips');
    }

    if (selectedCategory == 'Back') {
      return image.contains('back') ||
          name.contains('pull') ||
          name.contains('deadlift') ||
          name.contains('row') ||
          name.contains('lat');
    }

    if (selectedCategory == 'Arms') {
      return image.contains('biceps') ||
          name.contains('curl') ||
          name.contains('biceps') ||
          name.contains('hammer');
    }

    return true;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mealResults = filteredMeals;
    final workoutResults = filteredWorkouts;
    final totalResults = mealResults.length + workoutResults.length;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search meals or workouts',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category;

                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    selectedColor: ProfileScreen.mainColor,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : ProfileScreen.mainColor,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Results: $totalResults',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 16),

            if (mealResults.isNotEmpty) ...[
              const Text(
                'Meals',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mealResults.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  return _SearchMealCard(meal: mealResults[index]);
                },
              ),
              const SizedBox(height: 24),
            ],

            if (workoutResults.isNotEmpty) ...[
              const Text(
                'Workouts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: workoutResults.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  return _SearchWorkoutCard(workout: workoutResults[index]);
                },
              ),
            ],

            if (totalResults == 0)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  'Nothing found',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchMealCard extends StatelessWidget {
  final Meal meal;

  const _SearchMealCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0,
      closedColor: Colors.transparent,
      openColor: Colors.white,
      transitionDuration: const Duration(milliseconds: 600),
      openBuilder: (context, _) {
        return MealDetailScreen(meal: meal);
      },
      closedBuilder: (context, openContainer) {
        return GestureDetector(
          onTap: openContainer,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    meal.imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.mealTime,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        meal.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text('${meal.kiloCaloriesBurnt} kcal • ${meal.timeTaken} min'),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SearchWorkoutCard extends StatelessWidget {
  final UpperBodyWorkout workout;

  const _SearchWorkoutCard({required this.workout});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0,
      closedColor: Colors.transparent,
      openColor: Colors.white,
      transitionDuration: const Duration(milliseconds: 600),
      openBuilder: (context, _) {
        return WorkoutDetailScreen(workout: workout);
      },
      closedBuilder: (context, openContainer) {
        return GestureDetector(
          onTap: openContainer,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ProfileScreen.mainColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Image.asset(
                    workout.imagePath,
                    color: ProfileScreen.mainColor,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'WORKOUT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        workout.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        workout.instruction,
                        style: const TextStyle(
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _UserProfilePage extends StatefulWidget {
  const _UserProfilePage();

  @override
  State<_UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<_UserProfilePage> {
  final TextEditingController nameController =
  TextEditingController(text: 'Daryn');
  final TextEditingController weightController =
  TextEditingController(text: '72');
  final TextEditingController heightController =
  TextEditingController(text: '175');
  final TextEditingController goalController =
  TextEditingController(text: '2200');

  double? bmi;
  String bmiStatus = '';

  String selectedGoal = 'Maintain';
  String selectedActivity = 'Medium';

  String aiAdvice = '';
  String aiCaloriesAdvice = '';
  String aiWorkoutPlan = '';
  String aiMealPlan = '';

  final List<String> goals = [
    'Lose Weight',
    'Maintain',
    'Gain Muscle',
  ];

  final List<String> activities = [
    'Low',
    'Medium',
    'High',
  ];

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      nameController.text = prefs.getString('name') ?? 'Daryn';
      weightController.text = prefs.getString('weight') ?? '72';
      heightController.text = prefs.getString('height') ?? '175';
      goalController.text = prefs.getString('goal') ?? '2200';

      bmi = prefs.getDouble('bmi');
      bmiStatus = prefs.getString('bmiStatus') ?? '';

      selectedGoal = prefs.getString('selectedGoal') ?? 'Maintain';
      selectedActivity = prefs.getString('selectedActivity') ?? 'Medium';

      aiAdvice = prefs.getString('aiAdvice') ?? '';
      aiCaloriesAdvice = prefs.getString('aiCaloriesAdvice') ?? '';
      aiWorkoutPlan = prefs.getString('aiWorkoutPlan') ?? '';
      aiMealPlan = prefs.getString('aiMealPlan') ?? '';
    });
  }

  Future<void> saveProfile() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('name', nameController.text);
    await prefs.setString('weight', weightController.text);
    await prefs.setString('height', heightController.text);
    await prefs.setString('goal', goalController.text);

    await prefs.setString('bmiStatus', bmiStatus);
    await prefs.setString('selectedGoal', selectedGoal);
    await prefs.setString('selectedActivity', selectedActivity);

    await prefs.setString('aiAdvice', aiAdvice);
    await prefs.setString('aiCaloriesAdvice', aiCaloriesAdvice);
    await prefs.setString('aiWorkoutPlan', aiWorkoutPlan);
    await prefs.setString('aiMealPlan', aiMealPlan);

    if (bmi != null) {
      await prefs.setDouble('bmi', bmi!);
    }
  }

  void generateAiPlan() {
    final weight = double.tryParse(weightController.text);
    final heightCm = double.tryParse(heightController.text);
    final calories = int.tryParse(goalController.text);

    if (weight == null || heightCm == null || heightCm <= 0 || calories == null) {
      setState(() {
        bmi = null;
        bmiStatus = 'Введите правильные данные';
        aiAdvice = 'Please enter correct weight, height and calories.';
        aiCaloriesAdvice = '';
        aiWorkoutPlan = '';
        aiMealPlan = '';
      });

      saveProfile();
      return;
    }

    final heightM = heightCm / 100;
    final result = weight / (heightM * heightM);

    String status;
    if (result < 18.5) {
      status = 'Недостаточный вес';
    } else if (result < 25) {
      status = 'Нормальный вес';
    } else if (result < 30) {
      status = 'Лишний вес';
    } else {
      status = 'Ожирение';
    }

    String caloriesAdvice;
    String workoutPlan;
    String mealPlan;
    String mainAdvice;

    if (selectedGoal == 'Lose Weight') {
      caloriesAdvice =
      'Recommended calories: ${calories - 300} - ${calories - 500} kcal per day.';
      workoutPlan =
      'Workout plan: cardio 3 times per week + light strength training 2 times per week.';
      mealPlan =
      'Meal plan: more protein, vegetables, salads, less sugar and fried food.';
      mainAdvice =
      'AI advice: Your goal is fat loss. Focus on calorie deficit, daily walking, water tracking and regular workouts.';
    } else if (selectedGoal == 'Gain Muscle') {
      caloriesAdvice =
      'Recommended calories: ${calories + 300} - ${calories + 500} kcal per day.';
      workoutPlan =
      'Workout plan: strength training 4 times per week. Focus on chest, back, arms and legs.';
      mealPlan =
      'Meal plan: protein meals, eggs, chicken, rice, oatmeal, yogurt and healthy snacks.';
      mainAdvice =
      'AI advice: Your goal is muscle gain. Focus on progressive strength training and enough protein.';
    } else {
      caloriesAdvice =
      'Recommended calories: about $calories kcal per day.';
      workoutPlan =
      'Workout plan: balanced training 3 times per week + walking or stretching.';
      mealPlan =
      'Meal plan: balanced diet with protein, carbs, healthy fats and enough water.';
      mainAdvice =
      'AI advice: Your goal is maintenance. Keep stable activity, balanced diet and daily water intake.';
    }

    if (selectedActivity == 'Low') {
      workoutPlan += ' Start slowly: 20-30 minutes per session.';
    } else if (selectedActivity == 'Medium') {
      workoutPlan += ' Medium activity is good: 40-50 minutes per session.';
    } else {
      workoutPlan += ' High activity: add recovery days and stretching.';
    }

    if (result >= 25 && selectedGoal != 'Lose Weight') {
      mainAdvice +=
      ' Your BMI is above normal, so adding cardio and controlling calories is recommended.';
    }

    if (result < 18.5 && selectedGoal != 'Gain Muscle') {
      mainAdvice +=
      ' Your BMI is low, so increasing calories and protein is recommended.';
    }

    setState(() {
      bmi = result;
      bmiStatus = status;
      aiAdvice = mainAdvice;
      aiCaloriesAdvice = caloriesAdvice;
      aiWorkoutPlan = workoutPlan;
      aiMealPlan = mealPlan;
    });

    saveProfile();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AI fitness plan generated and saved'),
        backgroundColor: ProfileScreen.mainColor,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    weightController.dispose();
    heightController.dispose();
    goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 10),
            ClipOval(
              child: Image.asset(
                'assets/user.jpeg',
                width: 110,
                height: 110,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              nameController.text.isEmpty ? 'User Profile' : nameController.text,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Personal health information',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 24),

            _ProfileTextField(
              controller: nameController,
              label: 'Name',
              icon: Icons.person,
              keyboardType: TextInputType.text,
            ),
            _ProfileTextField(
              controller: weightController,
              label: 'Weight, kg',
              icon: Icons.monitor_weight,
              keyboardType: TextInputType.number,
            ),
            _ProfileTextField(
              controller: heightController,
              label: 'Height, cm',
              icon: Icons.height,
              keyboardType: TextInputType.number,
            ),
            _ProfileTextField(
              controller: goalController,
              label: 'Daily calorie goal',
              icon: Icons.local_fire_department,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 10),

            _ProfileDropdown(
              title: 'Fitness Goal',
              value: selectedGoal,
              items: goals,
              icon: Icons.flag,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  selectedGoal = value;
                });
                saveProfile();
              },
            ),

            _ProfileDropdown(
              title: 'Activity Level',
              value: selectedActivity,
              items: activities,
              icon: Icons.directions_run,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  selectedActivity = value;
                });
                saveProfile();
              },
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: generateAiPlan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ProfileScreen.mainColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Generate AI Fitness Plan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Column(
                children: [
                  const Text(
                    'BMI Result',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    bmi == null ? '--' : bmi!.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: ProfileScreen.mainColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    bmiStatus.isEmpty
                        ? 'Enter your data and generate AI plan'
                        : bmiStatus,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _AiPlanCard(
              title: 'AI Recommendation',
              icon: Icons.auto_awesome,
              text: aiAdvice.isEmpty
                  ? 'Generate AI plan to get a smart recommendation.'
                  : aiAdvice,
            ),
            _AiPlanCard(
              title: 'Calories',
              icon: Icons.local_fire_department,
              text: aiCaloriesAdvice.isEmpty
                  ? 'Calories advice will appear here.'
                  : aiCaloriesAdvice,
            ),
            _AiPlanCard(
              title: 'Workout Plan',
              icon: Icons.fitness_center,
              text: aiWorkoutPlan.isEmpty
                  ? 'Workout plan will appear here.'
                  : aiWorkoutPlan,
            ),
            _AiPlanCard(
              title: 'Meal Plan',
              icon: Icons.restaurant_menu,
              text: aiMealPlan.isEmpty
                  ? 'Meal recommendation will appear here.'
                  : aiMealPlan,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;

  const _ProfileTextField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: ProfileScreen.mainColor,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _ProfileDropdown extends StatelessWidget {
  final String title;
  final String value;
  final List<String> items;
  final IconData icon;
  final ValueChanged<String?> onChanged;

  const _ProfileDropdown({
    required this.title,
    required this.value,
    required this.items,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: title,
          prefixIcon: Icon(
            icon,
            color: ProfileScreen.mainColor,
          ),
          border: InputBorder.none,
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class _AiPlanCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String text;

  const _AiPlanCard({
    required this.title,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: ProfileScreen.mainColor,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: ProfileScreen.mainColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String title;

  const _CategoryChip({required this.title});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(title),
      backgroundColor: Colors.white,
      labelStyle: const TextStyle(
        color: ProfileScreen.mainColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileInfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: ProfileScreen.mainColor,
            size: 32,
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: ProfileScreen.mainColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutIcon extends StatelessWidget {
  final String asset;

  const _WorkoutIcon({required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: ProfileScreen.secondColor,
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Image.asset(
        asset,
        color: Colors.white,
      ),
    );
  }
}

class _IngredientProgress extends StatelessWidget {
  final String ingredient;
  final int leftAmount;
  final double progress;
  final Color progressColor;

  const _IngredientProgress({
    required this.ingredient,
    required this.leftAmount,
    required this.progress,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ingredient.toUpperCase(),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: progressColor,
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${leftAmount}g left',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}

class _RadialProgress extends StatelessWidget {
  final double height;
  final double width;
  final double progress;

  const _RadialProgress({
    required this.height,
    required this.width,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadialPainter(progress: progress),
      child: SizedBox(
        height: height,
        width: width,
        child: const Center(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '1731',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: ProfileScreen.mainColor,
                  ),
                ),
                TextSpan(text: '\n'),
                TextSpan(
                  text: 'kcal left',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ProfileScreen.mainColor,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _RadialPainter extends CustomPainter {
  final double progress;

  _RadialPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 10
      ..color = ProfileScreen.mainColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    final relativeProgress = 360 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.radians(-90),
      math.radians(-relativeProgress),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RadialPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _MealCard extends StatelessWidget {
  final Meal meal;

  const _MealCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 155,
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(22)),
        elevation: 4,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OpenContainer(
                closedElevation: 0,
                closedColor: Colors.white,
                openColor: Colors.white,
                transitionDuration: const Duration(milliseconds: 700),
                openBuilder: (context, _) {
                  return MealDetailScreen(meal: meal);
                },
                closedBuilder: (context, openContainer) {
                  return GestureDetector(
                    onTap: openContainer,
                    child: Image.asset(
                      meal.imagePath,
                      width: 155,
                      height: 105,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.mealTime,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        meal.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${meal.kiloCaloriesBurnt} kcal',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 15,
                            color: Colors.black26,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${meal.timeTaken} min',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(36),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.white,
        selectedItemColor: ProfileScreen.mainColor,
        unselectedItemColor: Colors.black26,
        iconSize: 34,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _WaterTrackerCard extends StatelessWidget {
  final int waterMl;
  final VoidCallback onAdd;
  final VoidCallback onReset;

  const _WaterTrackerCard({
    required this.waterMl,
    required this.onAdd,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    const goal = 2000;
    final progress = (waterMl / goal).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WATER TRACKER',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.water_drop,
                color: ProfileScreen.mainColor,
                size: 42,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  '$waterMl / $goal ml',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: ProfileScreen.mainColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            borderRadius: BorderRadius.circular(20),
            backgroundColor: Colors.black12,
            color: ProfileScreen.mainColor,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onAdd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ProfileScreen.mainColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    '+250 ml',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: onReset,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ProfileScreen.mainColor,
                    side: const BorderSide(color: ProfileScreen.mainColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}