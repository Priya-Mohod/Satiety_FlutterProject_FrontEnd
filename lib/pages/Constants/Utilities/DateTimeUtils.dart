import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

  static String getFormattedDate(Timestamp timestamp) {
    // Define your date format with AM/PM using DateFormat
    final DateFormat formatter = DateFormat('MMM dd, yyyy hh:mm a');

    // Format the Timestamp to a string
    final String formattedDate = formatter.format(timestamp.toDate());

    return formattedDate;
  }
}
