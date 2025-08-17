class Visit{
  final int? id;
  final int projetId;
  final DateTime date;
  final String note;

  Visit({
    this.id,
    required this.projetId,
    required this.date,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    final data = {
      'projectId': projetId,
      'date': date.toIso8601String().split('T').first,
      'note': note,
    };
    if (id != null) {
      data['id'] = id!;
    }
    return data;
  }
  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'],
      projetId: json['project'] != null ? json['project']['id'] : 0,
      // Parser la date au format ISO 8601
      date: DateTime.parse(json['date']),
      note: json['note'],
    );
  }
}