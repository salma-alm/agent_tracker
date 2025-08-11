import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Project.dart';
import '../models/Visit.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  // ------- PROJECTS -------

  Future<List<Projet>> getAllProjects() async {
    final response = await http.get(Uri.parse('$baseUrl/projects'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Projet.fromJson(json)).toList();
    } else {
      throw Exception('Échec de chargement des projets');
    }
  }

  Future<Projet> getProjectById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/projects/$id'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Projet.fromJson(json);
    } else {
      throw Exception('Échec de chargement du projet');
    }
  }

  Future<Projet> createProject(Projet projet) async {
    final response = await http.post(
      Uri.parse('$baseUrl/projects'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(projet.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return Projet.fromJson(json);
    } else {
      print('Erreur ${response.statusCode}: ${response.body}');
      throw Exception('Échec de création du projet');
    }
  }


  // ------- VISITS -------

  Future<List<Visit>> getAllVisits() async {
    final response = await http.get(Uri.parse('$baseUrl/visits'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Visit.fromJson(json)).toList();
    } else {
      throw Exception('Échec de chargement des visites');
    }
  }

  Future<List<Visit>> getVisitsByProject(int projectId) async {
    final response = await http.get(Uri.parse('$baseUrl/visits/project/$projectId'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Visit.fromJson(json)).toList();
    } else {
      throw Exception('Échec de chargement des visites du projet');
    }
  }

  Future<Visit> createVisit(Visit visit) async {
    final response = await http.post(
      Uri.parse('$baseUrl/visits'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(visit.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return Visit.fromJson(json);
    } else {
      throw Exception('Échec de création de la visite');
    }
  }
}
