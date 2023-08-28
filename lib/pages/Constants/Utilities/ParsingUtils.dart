class ParsingUtils {
  static String parseDoubleTo1Point(double value) {
    double roundedValue = double.parse(value.toStringAsFixed(1));
    return roundedValue.toString();
  }

  static String convertKmToMiles(dynamic value) {
    // check if value is a string
    if (value is String) {
      value = double.parse(value);
    }

    double miles = value * 0.621371;
    return parseDoubleTo1Point(miles);
  }
}
