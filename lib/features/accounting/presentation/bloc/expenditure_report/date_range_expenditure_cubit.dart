import 'package:flutter_bloc/flutter_bloc.dart';

enum DateRangeOption { today, last7Days, last30Days, custom }

class DateRangeExpenditureCubit extends Cubit<String> {
  DateRangeExpenditureCubit() : super(_getTodayRange());

  DateRangeOption selectedOption = DateRangeOption.today;

  // Mengembalikan rentang tanggal hari ini sampai hari ini
  static String _getTodayRange() {
    final today = DateTime.now();
    final formattedToday = _formatDate(today);
    return "$formattedToday - $formattedToday";
  }

  // Format tanggal
  static String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // Mengembalikan rentang 7 hari terakhir
  static String _getLast7DaysRange() {
    final today = DateTime.now();
    final startDate = today.subtract(Duration(days: 7));
    return "${_formatDate(startDate)} - ${_formatDate(today)}";
  }

  // Mengembalikan rentang 30 hari terakhir
  static String _getLast30DaysRange() {
    final today = DateTime.now();
    final startDate = today.subtract(Duration(days: 30));
    return "${_formatDate(startDate)} - ${_formatDate(today)}";
  }

  // Metode untuk memilih hari ini
  void selectToday() {
    selectedOption = DateRangeOption.today;
    emit(_getTodayRange());
  }

  // Metode untuk memilih rentang 7 hari terakhir
  void selectLast7Days() {
    selectedOption = DateRangeOption.last7Days;
    emit(_getLast7DaysRange());
  }

  // Metode untuk memilih rentang 30 hari terakhir
  void selectLast30Days() {
    selectedOption = DateRangeOption.last30Days;
    emit(_getLast30DaysRange());
  }

  // Metode untuk memilih rentang tanggal khusus (custom)
  void selectCustomRange(DateTime startDate, DateTime endDate) {
    selectedOption = DateRangeOption.custom;
    emit("${_formatDate(startDate)} - ${_formatDate(endDate)}");
  }
}
