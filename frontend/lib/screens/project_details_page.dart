import 'package:flutter/material.dart';
import '../models/Project.dart';
import '../models/Visit.dart';
import './add_visit_page.dart';
import '../services/api_service.dart';

class ProjectDetailsPage extends StatefulWidget {
  final Projet project;

  ProjectDetailsPage({super.key, required this.project});

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  late List<Visit> visits = [];

  void _ajouterVisite(Visit visit) {
    setState(() {
      visits.add(visit);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadVisits();
  }

  void _loadVisits() async {
    if (widget.project.id != null) {
      try {
        final data = await ApiService().getVisitsByProject(widget.project.id!);
        setState(() {
          visits = data;
        });
      } catch (e) {
        print('Erreur lors du chargement des visites : $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.project.titre)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Projet: ${widget.project.titre}',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Description: ${widget.project.description}'),
            const SizedBox(height: 10),
            const Divider(),
            const Text('Visites',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: visits.length,
                itemBuilder: (context, index) {
                  final visit = visits[index];
                  return ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text('Date: ${visit.date.toLocal().toString().split(' ')[0]}'),
                    subtitle: Text(visit.remarque),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final nouvelleVisite = await Navigator.push<Visit>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddVisit(projectId: widget.project.id!),
                  ),
                );

                if (nouvelleVisite != null) {
                  _ajouterVisite(nouvelleVisite);
                }
              },
              child: Text("Ajouter une visite ou remarque"),
            ),
          ],
        ),
      ),
    );
  }
}
