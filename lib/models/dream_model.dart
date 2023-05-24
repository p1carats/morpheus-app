enum DreamType { dream, nightmare }

class DreamModel {
  final String? id;
  final String title;
  final String description;
  final DateTime date;
  final DreamType type;
  final int rating;
  final bool isRecurrent;
  final bool isLucid;
  final bool isControllable;

  DreamModel({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.rating,
    required this.isRecurrent,
    required this.isLucid,
    required this.isControllable,
  }) {
    if (rating < 1 || rating > 5) {
      throw Exception('Invalid dream rating');
    }
  }

  DreamModel copyWith({String? id}) {
    return DreamModel(
      id: id ?? this.id,
      title: title,
      description: description,
      date: date,
      type: type,
      rating: rating,
      isRecurrent: isRecurrent,
      isLucid: isLucid,
      isControllable: isControllable,
    );
  }

  factory DreamModel.fromJson(Map<String, dynamic> json) {
    return DreamModel(
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      date: json['date'].toDate(),
      type: json['type'] == 'dream' ? DreamType.dream : DreamType.nightmare,
      rating: (json['rating'] as num).toInt(),
      isRecurrent: json['isRecurrent'] as bool,
      isLucid: json['isLucid'] as bool,
      isControllable: json['isControllable'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'type': type == DreamType.dream ? 'dream' : 'nightmare',
      'rating': rating,
      'isRecurrent': isRecurrent,
      'isLucid': isLucid,
      'isControllable': isControllable,
    };
  }
}
