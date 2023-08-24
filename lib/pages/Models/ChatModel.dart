import 'package:satietyfrontend/pages/Models/FoodRequestsModel.dart';
import 'package:satietyfrontend/pages/Models/UserModel.dart';

class Chat {
  final int? id;
  final FoodRequest foodRequest;
  final String text;
  final User textBy;
  final bool supplierFlag;
  final bool consumerFlag;

  Chat({
    required this.id,
    required this.foodRequest,
    required this.text,
    required this.textBy,
    required this.supplierFlag,
    required this.consumerFlag,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['foodRequestId'],
      foodRequest: FoodRequest.fromJson(json['foodRequest']),
      text: json['text'],
      textBy: User.fromJson(json['textBy']),
      supplierFlag: json['supplierFlag'],
      consumerFlag: json['consumerFlag'],
    );
  }
}
