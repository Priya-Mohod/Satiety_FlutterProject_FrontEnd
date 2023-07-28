class FoodItem {
  final int foodId;
  final String foodName;
  final String foodDescription;
  final int foodQuantity;

  FoodItem({
    required this.foodId,
    required this.foodName,
    required this.foodDescription,
    required this.foodQuantity,
  });

  // Factory method to create a FoodItem from JSON
  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      foodId: json['foodId'],
      foodName: json['foodName'],
      foodDescription: json['foodDescription'],
      foodQuantity: json['foodQuantity'],
    );
  }
}
