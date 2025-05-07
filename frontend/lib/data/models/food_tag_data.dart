import 'dart:convert';

class FoodTagData {
  final String name;

  FoodTagData({required this.name});

  factory FoodTagData.fromJson(Map<String, dynamic> json) {
    return FoodTagData(name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  @override
  String toString() => jsonEncode(toJson());
}
