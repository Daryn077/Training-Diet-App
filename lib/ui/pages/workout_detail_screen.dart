import 'package:darynfit/model/upper_body_workout.dart';
import 'package:flutter/material.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final UpperBodyWorkout workout;

  const WorkoutDetailScreen({
    super.key,
    required this.workout,
  });

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  final List<bool> completedSets = [false, false, false, false];

  int get completedCount => completedSets.where((item) => item).length;

  double get progress => completedCount / completedSets.length;

  void finishWorkout() {
    setState(() {
      for (int i = 0; i < completedSets.length; i++) {
        completedSets[i] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Workout completed! Good job!'),
        backgroundColor: Color(0xFF200087),
      ),
    );
  }

  void resetWorkout() {
    setState(() {
      for (int i = 0; i < completedSets.length; i++) {
        completedSets[i] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF200087);

    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),
      appBar: AppBar(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        title: Text(widget.workout.name),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      widget.workout.imagePath,
                      width: 120,
                      height: 120,
                      color: mainColor,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      widget.workout.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.workout.instruction,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const _InfoCard(
                title: 'Recommended sets',
                value: '4 sets',
                icon: Icons.fitness_center,
              ),
              const _InfoCard(
                title: 'Rest time',
                value: '60 seconds',
                icon: Icons.timer,
              ),
              const _InfoCard(
                title: 'Difficulty',
                value: 'Beginner',
                icon: Icons.trending_up,
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Workout Progress',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$completedCount / ${completedSets.length} sets completed',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                      borderRadius: BorderRadius.circular(20),
                      backgroundColor: Colors.black12,
                      color: mainColor,
                    ),
                    const SizedBox(height: 18),

                    for (int i = 0; i < completedSets.length; i++)
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        activeColor: mainColor,
                        value: completedSets[i],
                        onChanged: (value) {
                          setState(() {
                            completedSets[i] = value ?? false;
                          });
                        },
                        title: Text(
                          'Set ${i + 1} completed',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          i == 0
                              ? 'Warm-up set'
                              : 'Main working set ${i + 1}',
                          style: const TextStyle(
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: finishWorkout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              'Finish Workout',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: resetWorkout,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: mainColor,
                              side: const BorderSide(color: mainColor),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              'Reset',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF200087);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(icon, color: mainColor, size: 30),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: mainColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}