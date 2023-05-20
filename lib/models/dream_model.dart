import 'package:cloud_firestore/cloud_firestore.dart';

class DreamModel {
  final String? id;
  final String title;
  final String description;
  final DateTime date;
  final String type; // dream or nightmare
  final int rating; // 1 to 5
  final bool isLucid;
  final bool isControllable;

  DreamModel({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.rating,
    required this.isLucid,
    required this.isControllable,
  });

  DreamModel copyWith({String? id}) {
    return DreamModel(
      id: id ?? this.id,
      title: title,
      description: description,
      date: date,
      type: type,
      rating: rating,
      isLucid: isLucid,
      isControllable: isControllable,
    );
  }

  // Conversion from JSON to Dream object
  factory DreamModel.fromJson(Map<String, dynamic> json) {
    return DreamModel(
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      date: json['date'].toDate(),
      type: json['type'] as String,
      rating: (json['rating'] as num).toInt(),
      isLucid: json['isLucid'] as bool,
      isControllable: json['isControllable'] as bool,
    );
  }

  // Conversion from Dream object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'type': type,
      'rating': rating,
      'isLucid': isLucid,
      'isControllable': isControllable,
    };
  }
}
