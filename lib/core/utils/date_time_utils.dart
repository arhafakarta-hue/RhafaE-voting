class DateTimeUtils {
  static String formatTime(DateTime dateTime) {
    final jam = dateTime.hour.toString().padLeft(2, '0');
    final menit = dateTime.minute.toString().padLeft(2, '0');
    return '$jam:$menit';
  }

  static String formatDate(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    return '$day/$month/$year';
  }

  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} ${formatTime(dateTime)}';
  }
}
