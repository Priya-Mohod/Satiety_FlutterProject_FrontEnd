import 'package:satietyfrontend/pages/Constants/Utilities/DevelopmentConfig.dart';

class FilterConstants {
  final String value;

  const FilterConstants._(this.value);

  static const FilterConstants foodType_all =
      FilterConstants._("All_Veg_Non-Veg");
  static const FilterConstants foodType_veg = FilterConstants._("Veg");
  static const FilterConstants foodType_non_veg = FilterConstants._("Non-veg");
  static const FilterConstants foodAmount_all =
      FilterConstants._("All_Free_Chargeable");
  static const FilterConstants foodAmount_free = FilterConstants._("Free");
  static const FilterConstants foodAmount_chargeable =
      FilterConstants._("Chargeable");
  static const FilterConstants foodAvailability_all =
      FilterConstants._("All_Available_Just Gone");
  static const FilterConstants foodAvailability_available =
      FilterConstants._("Available");
  static const FilterConstants foodAvailability_just_gone =
      FilterConstants._("Just Gone");
  static const FilterConstants filter_distance = FilterConstants._("Distance");

  static String getDistanceFilterValue(DistanceFilter distanceFilterValue) {
    String filterDistanceString = "";
    switch (distanceFilterValue) {
      case DistanceFilter.five:
        filterDistanceString = '5';
        break;
      case DistanceFilter.seven:
        filterDistanceString = '7';
        break;
      case DistanceFilter.nine:
        filterDistanceString = '9';
        break;
      case DistanceFilter.twelve:
        filterDistanceString = '12';
        break;
      case DistanceFilter.fifteen:
        filterDistanceString = '15';
        break;
      case DistanceFilter.twenty:
        filterDistanceString = '20';
        break;
      case DistanceFilter.thirty:
        filterDistanceString = '30';
        break;
      default:
        '';
    }
    return filterDistanceString;
  }
}
