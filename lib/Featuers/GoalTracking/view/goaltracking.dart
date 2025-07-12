import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GoalTrackingPage extends StatefulWidget {
  final String title;
  final String category;

  GoalTrackingPage({required this.title, required this.category});

  @override
  _GoalTrackingPageState createState() => _GoalTrackingPageState();
}

class _GoalTrackingPageState extends State<GoalTrackingPage> {
  final TextEditingController milestoneController = TextEditingController();
  List<Map<String, dynamic>> goals = [];

  @override
  void initState() {
    super.initState();
    _loadMilestones();
  }

  Future<void> _loadMilestones() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? milestonesData = prefs.getString('milestones');
    if (milestonesData != null) {
      List<dynamic> decodedData = jsonDecode(milestonesData);
      setState(() {
        goals = decodedData.map((milestone) => Map<String, dynamic>.from(milestone)).toList();
      });
    }
  }
  Future<void> _saveMilestones() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = jsonEncode(goals);
    prefs.setString('milestones', encodedData);
  }

  // إضافة معلم جديد
  void addMilestone(String milestone) {
    setState(() {
      goals.add({"title": milestone, "completed": false});
    });
    _saveMilestones();
  }

  @override
  Widget build(BuildContext context) {
    double progress = goals.isEmpty
        ? 0.0
        : goals.where((milestone) => milestone['completed'] == true).length / goals.length;

    int percentage = (progress * 100).toInt();

    String progressStatus;
    if (percentage == 100) {
      progressStatus = 'Completed!';
    } else if (percentage >= 75) {
      progressStatus = 'Almost there!';
    } else if (percentage >= 50) {
      progressStatus = 'Halfway!';
    } else if (percentage > 0) {
      progressStatus = 'Keep going!';
    } else {
      progressStatus = 'Not started yet';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals Tracking'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 200,
                width: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: CircularProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                        strokeWidth: 12.0,
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: _getTextSize(percentage),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              progressStatus,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Goal Title: ${widget.title}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 108, 2, 78),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Category: ${widget.category}",
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 108, 2, 78),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: milestoneController,
                              decoration: const InputDecoration(
                                labelText: 'Enter Milestone',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                if (milestoneController.text.isNotEmpty) {
                                  addMilestone(milestoneController.text);
                                  Navigator.pop(context);
                                  milestoneController.clear();
                                }
                              },
                              child: const Text('Add Milestone'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text('Add Milestone'),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final milestone = goals[index];
                return CheckboxListTile(
                  title: Text(milestone['title']),
                  value: milestone['completed'],
                  onChanged: (bool? value) {
                    setState(() {
                      milestone['completed'] = value!;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _getTextSize(int percentage) {
    if (percentage >= 90) {
      return 50.0;
    } else if (percentage >= 50) {
      return 40.0;
    } else {
      return 30.0;
    }
  }
}
