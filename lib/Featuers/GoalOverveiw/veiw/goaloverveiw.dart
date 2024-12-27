import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../GoalTracking/goaltracking.dart';
import '../GoalController/cubit/goals_cubit.dart';

class GoalOverviewPage extends StatefulWidget {
  final String goalTitle;
  final String goalCategory;
  final double progress;
  final List<Map<String, dynamic>> milestones;

  const GoalOverviewPage({
    Key? key,
    required this.goalTitle,
    required this.goalCategory,
    required this.progress,
    required this.milestones,
  }) : super(key: key);

  @override
  State<GoalOverviewPage> createState() => _GoalOverviewPageState();
}

class _GoalOverviewPageState extends State<GoalOverviewPage> {
  Box? goalBox;

  @override
  void initState() {
    super.initState();
    _openHiveBox();
  }

  Future<void> _openHiveBox() async {
    goalBox = await Hive.openBox('goals');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals Overview'),
        backgroundColor: const Color.fromARGB(255, 246, 233, 252),
      ),
      body: BlocBuilder<GoalsCubit, GoalsState>(
        builder: (context, state) {
          if (state is GoalsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GoalsLoaded) {
            final goals = state.goals;
            if (goals.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.emoji_objects_outlined,
                      color: Colors.amber,
                      size: 80,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "No Goals Yet!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Start by adding your first goal to track your progress.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/creation');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Add Your First Goal',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GoalTrackingPage(
                                title: goal.title,
                                category: goal.category,
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 246, 233, 252),
                            
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    goal.title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    goal.category,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // استدعاء دالة الحذف من الـ Cubit
                                  context.read<GoalsCubit>().deleteGoal(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          } else if (state is GoalsError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return const Center(child: Text("Unknown state"));
          }
        },
      ),
    );
  }
}
