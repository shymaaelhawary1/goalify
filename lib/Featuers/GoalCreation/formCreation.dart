import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goalify/Featuers/GoalOverveiw/veiw/Home.dart';
import 'package:goalify/Featuers/GoalOverveiw/veiw/goaloverveiw.dart';
import 'package:goalify/Featuers/GoalCreation/goalcreate.dart';
import 'package:goalify/Featuers/GoalOverveiw/GoalController/cubit/goals_cubit.dart';

class FormCreation extends StatefulWidget {
  final String? goalTitle;
  final String? goalCategory;

  const FormCreation({Key? key, this.goalTitle, this.goalCategory})
      : super(key: key);

  @override
  _FormCreationState createState() => _FormCreationState();
}

class _FormCreationState extends State<FormCreation> {
  final TextEditingController goalNameController = TextEditingController();
  final TextEditingController otherCategoryController = TextEditingController();
  final List<String> categories = [
    "Fitness & Health",
    "Career & Education",
    "Personal Development",
    "Financial Goals",
    "Relationship Goals",
    "Hobbies & Interests",
    "Travel & Adventure",
    "Family & Home",
    "Social Impact",
    "Other"
  ];
  String? selectedCategory;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    goalNameController.text = widget.goalTitle ?? '';
    selectedCategory = widget.goalCategory?.isNotEmpty ?? false
        ? widget.goalCategory
        : categories[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Create New Goal',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5D4E0),
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.star,
                          size: 50, color: Color.fromARGB(255, 245, 245, 6)),
                      SizedBox(height: 10),
                      Text(
                        "Set Your Goals, Achieve Your Dreams!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF4A4A4A),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "The journey of a thousand miles begins with a single step.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF6C63FF),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Goal Title:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: goalNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your goal',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF6C63FF)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a goal title.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Goal Category:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                if (selectedCategory == "Other") ...[
                  const Text(
                    'Specify Your Category:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A4A4A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: otherCategoryController,
                    decoration: InputDecoration(
                      hintText: 'Enter your custom category',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF6C63FF)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (selectedCategory == "Other" &&
                          (value == null || value.trim().isEmpty)) {
                        return 'Please specify your category.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                ],
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final title = goalNameController.text.trim();
                        final category = selectedCategory == "Other"
                            ? otherCategoryController.text.trim()
                            : selectedCategory;

                        context
                            .read<GoalsCubit>()
                            .addGoal(title, category ?? "");
                        GoalOverviewPage(
                          goalTitle: title,
                          goalCategory: category ?? "",
                          progress: 0.0,
                          milestones: [],
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE5D4E0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text(
                      'Add Goal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
