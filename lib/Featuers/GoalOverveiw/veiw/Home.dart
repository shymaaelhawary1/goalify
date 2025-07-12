import 'package:flutter/material.dart';
import 'package:goalify/Featuers/GoalCreation/veiw/goalcreate.dart';
import 'package:goalify/Featuers/GoalOverveiw/veiw/goaloverveiw.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _GoalOverviewPageState();
}

class _GoalOverviewPageState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const GoalOverviewPage(
        goalTitle: '', goalCategory: '', progress: 0.0, milestones: []),
    GoalCreationPage(),
  ];

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex, 
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 246, 233, 252),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Create Goal',
          ),
        ],
      ),
    );
  }
}
