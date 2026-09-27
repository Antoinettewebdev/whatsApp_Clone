import '../models/expense.dart';

/// Date-range helpers for dashboard totals and chart data.
class DateFilters {
  /// True if [date] falls on the same calendar day as [reference].
  static bool isSameDay(DateTime date, DateTime reference) {
    return date.year == reference.year &&
        date.month == reference.month &&
        date.day == reference.day;
  }

  /// True if [date] is in the same ISO week as [reference] (Mon–Sun).
  static bool isSameWeek(DateTime date, DateTime reference) {
    final start = startOfWeek(reference);
    final end = start.add(const Duration(days: 7));
    return !date.isBefore(start) && date.isBefore(end);
  }

  /// True if [date] is in the same month as [reference].
  static bool isSameMonth(DateTime date, DateTime reference) {
    return date.year == reference.year && date.month == reference.month;
  }

  /// Monday 00:00 of the week containing [date].
  static DateTime startOfWeek(DateTime date) {
    final weekday = date.weekday; // 1 = Monday
    return DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: weekday - 1));
  }

  /// Sum amounts for expenses matching [predicate].
  static double sumWhere(
    List<Expense> expenses,
    bool Function(Expense expense) predicate,
  ) {
    return expenses
        .where(predicate)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  /// Totals grouped by category.
  static Map<String, double> totalsByCategory(List<Expense> expenses) {
    final map = <String, double>{};
    for (final expense in expenses) {
      map[expense.category] = (map[expense.category] ?? 0) + expense.amount;
    }
    return map;
  }

  /// Last 7 days: label -> total spent that day.
  static Map<String, double> weeklyTrend(List<Expense> expenses) {
    final now = DateTime.now();
    final result = <String, double>{};

    for (var i = 6; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day - i);
      final label = _weekdayLabel(day.weekday);
      result[label] = DateFilters.sumWhere(
        expenses,
        (e) => isSameDay(e.date, day),
      );
    }
    return result;
  }

  /// Last 6 months: label -> total spent that month.
  static Map<String, double> monthlyTrend(List<Expense> expenses) {
    final now = DateTime.now();
    final result = <String, double>{};

    for (var i = 5; i >= 0; i--) {
      final monthDate = DateTime(now.year, now.month - i, 1);
      final label = _monthLabel(monthDate.month);
      result[label] = DateFilters.sumWhere(
        expenses,
        (e) =>
            e.date.year == monthDate.year && e.date.month == monthDate.month,
      );
    }
    return result;
  }

  static String _weekdayLabel(int weekday) {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return labels[weekday - 1];
  }

  static String _monthLabel(int month) {
    const labels = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return labels[month - 1];
  }
}
