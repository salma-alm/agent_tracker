class Projet {
  final int? id;
  final String titre;
  final String description;
  final double latitude;
  final double longitude;

  Projet({
    this.id,
    required this.titre,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    final data = {
      'titre': titre,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
    if (id != null) {
      data['id'] = id!;
    }
    return data;
    }
  factory Projet.fromJson(Map<String, dynamic> json) {
    return Projet(
      id: json['id'],
      titre: json['titre'],
      description: json['description'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }
  }

