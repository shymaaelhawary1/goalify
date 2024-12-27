import 'package:flutter/material.dart';
import 'package:goalify/Featuers/GoalCreation/formCreation.dart';

class GoalCreationPage extends StatelessWidget {
  final List<Map<String, dynamic>> popularGoals = [
    {
      "icon": Icons.fitness_center,
      "color": Colors.pinkAccent,
      "title": "Fitness & Health",
      "subtitle": "STAY FIT & HEALTHY"
    },
    {
      "icon": Icons.school,
      "color": Colors.blueAccent,
      "title": "Career & Education",
      "subtitle": "ADVANCE YOUR CAREER"
    },
    {
      "icon": Icons.person,
      "color": Colors.tealAccent,
      "title": "Personal Development",
      "subtitle": "GROW YOURSELF"
    },
    {
      "icon": Icons.money,
      "color": Colors.greenAccent,
      "title": "Financial Goals",
      "subtitle": "SAVE & INVEST"
    },
    {
      "icon": Icons.people,
      "color": Colors.deepPurpleAccent,
      "title": "Relationship Goals",
      "subtitle": "BUILD CONNECTIONS"
    },
    {
      "icon": Icons.palette,
      "color": Colors.amberAccent,
      "title": "Hobbies & Interests",
      "subtitle": "EXPLORE YOUR PASSIONS"
    },
    {
      "icon": Icons.flight,
      "color": Colors.orangeAccent,
      "title": "Travel & Adventure",
      "subtitle": "EXPLORE THE WORLD"
    },
    {
      "icon": Icons.home,
      "color": Colors.lightBlueAccent,
      "title": "Family & Home",
      "subtitle": "IMPROVE FAMILY LIFE"
    },
    {
      "icon": Icons.volunteer_activism,
      "color": Colors.redAccent,
      "title": "Social Impact",
      "subtitle": "MAKE A DIFFERENCE"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create New Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormCreation()),
                );
              },
              child: const Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 235, 207, 226),
                    child: Text('+', style: TextStyle(fontSize: 24)),
                  ),
                  title: Text('Create Your Goal'),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Popular Goals',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'This is the most popular Goals among the users',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 110, 110, 110),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: popularGoals.length,
                itemBuilder: (context, index) {
                  final goal = popularGoals[index];
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: goal['color'],
                          child: Icon(
                            goal['icon'],
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          goal['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          goal['subtitle'],
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color.fromARGB(255, 99, 98, 98),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormCreation(
                                goalTitle: goal['subtitle'],
                                goalCategory: goal['title'],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
