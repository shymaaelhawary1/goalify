import 'package:hive/hive.dart';

part 'GoalModel.g.dart';

@HiveType(typeId: 0)
class Goal {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final bool completed;

  Goal({
    required this.title,
    required this.category,
    this.completed = false,
  });
}
