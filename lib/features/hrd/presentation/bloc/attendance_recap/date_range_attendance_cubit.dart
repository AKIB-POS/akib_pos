import 'package:flutter_bloc/flutter_bloc.dart';

enum DateRangeOption { today, last7Days, last30Days, custom }

class DateRangeAttendanceCubit extends Cubit<String> {
  DateRangeAttendanceCubit() : super(_getTodayRange());

  DateRangeOption selectedOption = DateRangeOption.today;

  // Returns today's date range
  static String _getTodayRange() {
    final today = DateTime.now();
    final formattedToday = _formatDate(today);
    return "$formattedToday - $formattedToday";
  }

  // Formats the date
  static String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // Returns the last 7 days range
  static String _getLast7DaysRange() {
    final today = DateTime.now();
    final startDate = today.subtract(Duration(days: 7));
    return "${_formatDate(startDate)} - ${_formatDate(today)}";
  }

  // Returns the last 30 days range
  static String _getLast30DaysRange() {
    final today = DateTime.now();
    final startDate = today.subtract(Duration(days: 30));
    return "${_formatDate(startDate)} - ${_formatDate(today)}";
  }

  // Method to select today's range
  void selectToday() {
    selectedOption = DateRangeOption.today;
    emit(_getTodayRange());
  }

  // Method to select the last 7 days range
  void selectLast7Days() {
    selectedOption = DateRangeOption.last7Days;
    emit(_getLast7DaysRange());
  }

  // Method to select the last 30 days range
  void selectLast30Days() {
    selectedOption = DateRangeOption.last30Days;
    emit(_getLast30DaysRange());
  }

  // Method to select a custom date range
  void selectCustomRange(DateTime startDate, DateTime endDate) {
    selectedOption = DateRangeOption.custom;
    emit("${_formatDate(startDate)} - ${_formatDate(endDate)}");
  }
}
