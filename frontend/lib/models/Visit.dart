class Visit{
  final int? id;
  final int projetId;
  final DateTime date;
  final String remarque;

  Visit({
    this.id,
    required this.projetId,
    required this.date,
    required this.remarque,
  });

  Map<String, dynamic> toJson() {
    final data = {
      'projetId': projetId,
      'date': date.toIso8601String(),
      'remarque': remarque,
    };
    if (id != null) {
      data['id'] = id!;
    }
    return data;
  }
  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'],
      projetId: json['projetId'],
      // Parser la date au format ISO 8601
      date: DateTime.parse(json['date']),
      remarque: json['remarque'],
    );
  }
}