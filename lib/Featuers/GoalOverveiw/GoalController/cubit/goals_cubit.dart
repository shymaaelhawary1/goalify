import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../model/GoalModel.dart';

part 'goals_state.dart';

class GoalsCubit extends Cubit<GoalsState> {
  GoalsCubit() : super(GoalsInitial()) {
    loadGoals(); 
  }

  static const String goalsBoxName = 'goals_box';

  Future<void> loadGoals() async {
    emit(GoalsLoading()); // حالة التحميل
    try {
      final box = await Hive.openBox<Goal>(goalsBoxName);
      final goals = box.values.toList();
      emit(GoalsLoaded(goals)); // حالة التحميل الناجح
    } catch (e) {
      emit(GoalsError("Failed to load goals.")); 
    }
  }

  Future<void> addGoal(String title, String category) async {
    try {
      final box = await Hive.openBox<Goal>(goalsBoxName);
      final newGoal = Goal(title: title, category: category);
      await box.add(newGoal);
      emit(GoalsLoaded(box.values.toList())); // تحديث الحالة بعد الإضافة
    } catch (e) {
      emit(GoalsError("Failed to add goal.")); // حالة الخطأ
    }
  }

  Future<void> completeGoal(int index) async {
    try {
      final box = await Hive.openBox<Goal>(goalsBoxName);
      final goal = box.getAt(index);
      if (goal != null) {
        final updatedGoal = Goal(
          title: goal.title,
          category: goal.category,
          completed: true,
        );
        await box.putAt(index, updatedGoal);
        emit(GoalsLoaded(box.values.toList())); // تحديث الحالة
      }
    } catch (e) {
      emit(GoalsError("Failed to complete goal.")); // حالة الخطأ
    }
  }
Future<void> deleteGoal(int index) async {
  try {
    final box = await Hive.openBox<Goal>(goalsBoxName);
    await box.deleteAt(index);
    emit(GoalsLoaded(box.values.toList())); // تحديث الحالة بعد الحذف
  } catch (e) {
    emit(GoalsError("Failed to delete goal.")); // حالة الخطأ
  }
}

}
