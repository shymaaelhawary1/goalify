part of 'goals_cubit.dart';

@immutable
abstract class GoalsState {}

/// الحالة الأولية
class GoalsInitial extends GoalsState {}

/// حالة التحميل
class GoalsLoading extends GoalsState {}

/// حالة التحميل الناجح
class GoalsLoaded extends GoalsState {
  final List<Goal> goals;

  GoalsLoaded(this.goals);
}

/// حالة الخطأ
class GoalsError extends GoalsState {
  final String errorMessage;

  GoalsError(this.errorMessage);
}
