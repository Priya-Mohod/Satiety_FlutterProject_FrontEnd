class DateTimeUtils {
  static Map<String, dynamic> parseDateTime(String dateTimeString) {
    DateTime parsedDateTime = DateTime.parse(dateTimeString);
    DateTime now = DateTime.now();

    int hour = parsedDateTime.hour;
    String amPm = hour < 12 ? 'AM' : 'PM';

    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    int differenceInDays = now.difference(parsedDateTime).inDays;

    return {
      'year': parsedDateTime.year,
      'month': parsedDateTime.month,
      'day': parsedDateTime.day,
      'hour': hour,
      'minute': parsedDateTime.minute,
      'second': parsedDateTime.second,
      'amPm': amPm,
      'differenceInDays': differenceInDays,
      'dateTime': parsedDateTime, // Add this line to return the DateTime object
    };
  }
}
