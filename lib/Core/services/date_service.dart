import 'package:intl/intl.dart';

class DateService {
  static int getWeekdayNumber(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return 1;
      case 'tuesday':
        return 2;
      case 'wednesday':
        return 3;
      case 'thursday':
        return 4;
      case 'friday':
        return 5;
      case 'saturday':
        return 6;
      case 'sunday':
        return 7;
      default:
        return 1;
    }
  }

  static DateTime getNextWeekday(String weekdayName) {
    final DateTime now = DateTime.now();
    final int currentWeekday = now.weekday;
    final int targetWeekday = getWeekdayNumber(weekdayName);

    int daysToAdd = targetWeekday - currentWeekday;
    if (daysToAdd <= 0) {
      daysToAdd += 7;
    }

    return now.add(Duration(days: daysToAdd));
  }

  static String formatDateDDMMYYYY(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static DateTime parseTimeString(String time) {
    final parts = time.split(':');
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  static String formatTime12Hour(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  static Map<String, List<String>> generateAvailableSlotsFromDoctor(
    Map<String, List<String>> doctorAvailability,
  ) {
    final Map<String, List<String>> availableSlots = {};

    doctorAvailability.forEach((day, timeRanges) {
      final List<String> daySlots = [];

      for (final range in timeRanges) {
        final times = range.split('-');
        if (times.length == 2) {
          final start = parseTimeString(times[0].trim());
          final end = parseTimeString(times[1].trim());
          final slots = <String>[];
          var current = start;

          while (current.isBefore(end)) {
            slots.add(formatTime12Hour(current));
            current = current.add(const Duration(minutes: 15));
          }

          daySlots.addAll(slots);
        }
      }

      if (daySlots.isNotEmpty) {
        availableSlots[day] = daySlots;
      }
    });

    return availableSlots;
  }
}
