import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/Project.dart';
import '../screens/add_project_page.dart';
import '../screens/project_details_page.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final api = ApiService();
  List<Projet> projets = [];

  final MapController _mapController = MapController();

  Future<void> loadProjects() async {
    final data = await api.getAllProjects();
    print("✅ Données récupérées du backend : $data");
    setState(() {
      projets = data;
    });
  }

  @override
  void initState() {
    super.initState(); // Toujours appeler la méthode parent !
    loadProjects();    // Ici, on charge les projets au démarrage
  }

  void _ajouterProjet(Projet projet) async {
    await api.createProject(projet);
    await loadProjects();
    _mapController.move(
      LatLng(projet.latitude, projet.longitude),
      10,
    );

    // Recentrer la carte sur le nouveau projet
    _mapController.move(
      LatLng(projet.latitude, projet.longitude),
      10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carte des projets')),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: LatLng(33.5899, -7.6039),
          zoom: 5,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: projets.map((projet) {
              return Marker(
                width: 80,
                height: 80,
                point: LatLng(projet.latitude, projet.longitude),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProjectDetailsPage(project: projet),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final nouveauProjet = await Navigator.push<Projet>(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProjectPage(),
            ),
          );

          // Si un projet a été retourné (c’est-à-dire que l’utilisateur a cliqué sur "Ajouter")
          if (nouveauProjet != null) {
            _ajouterProjet(nouveauProjet);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
