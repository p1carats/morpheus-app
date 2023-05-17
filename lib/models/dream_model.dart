class DreamModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String type; // dream or nightmare
  final int rating; // 1 to 5
  final bool isLucid;

  DreamModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.rating,
    required this.isLucid,
  });

  // Conversion from JSON to Dream object
  factory DreamModel.fromJson(Map<String, dynamic> json) {
    return DreamModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'].toDate(),
      type: json['type'] ?? 'dream',
      rating: json['rating'].toInt() ?? 1,
      isLucid: json['isLucid'] ?? false,
    );
  }

  // Conversion from Dream object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'type': type,
      'rating': rating,
      'isLucid': isLucid,
    };
  }
}
