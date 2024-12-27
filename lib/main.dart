import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goalify/Featuers/GoalCreation/goalcreate.dart';
import 'package:goalify/Featuers/GoalOverveiw/veiw/goaloverveiw.dart';
import 'package:goalify/Featuers/GoalTracking/goaltracking.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Featuers/GoalCreation/formCreation.dart';
import 'Featuers/GoalOverveiw/GoalController/cubit/goals_cubit.dart';
import 'Featuers/GoalOverveiw/model/GoalModel.dart';
import 'Featuers/GoalOverveiw/veiw/Home.dart';
import 'Featuers/OnBoarding/onboardingpage1.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(GoalAdapter());
  await Hive.openBox('goalsBox');

  final prefs = await SharedPreferences.getInstance();
  final bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => BlocProvider(
        create: (context) => GoalsCubit(),
        child: MyApp(isFirstRun: isFirstRun),
      ),
    ),
  );

  if (isFirstRun) {
    prefs.setBool('isFirstRun', false);
  }
}

class MyApp extends StatelessWidget {
  final bool isFirstRun;

  const MyApp({super.key, required this.isFirstRun});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: DevicePreview.appBuilder,
      initialRoute: isFirstRun ? '/onboarding1' : '/',
      routes: {
        '/': (context) => const GoalOverviewPage(
              goalTitle: '',
              goalCategory: '',
              progress: 0.0,
              milestones: [],
            ),
        '/form': (context) => const FormCreation(),
        '/creation': (context) => GoalCreationPage(),
        '/Home': (context) => const Home(),
        '/onboarding1': (context) => const OnboardingPage1(),
      },
    );
  }
}
