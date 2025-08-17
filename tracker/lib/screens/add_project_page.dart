import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/Project.dart';

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({Key? key}) : super(key: key);

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final _formKey = GlobalKey<FormState>();

  String nom = '';
  String description = '';
  double? latitude;
  double? longitude;

  bool isLoadingLocation = false;
  String locationStatusMessage = '';


  Future<bool> _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print("demande de permission");
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<void> _getLocation() async {
    setState(() {
      isLoadingLocation = true;
      locationStatusMessage = 'Récupération de la localisation...';
    });

    bool permissionGranted = await _checkPermission();
    if (!permissionGranted) {
      setState(() {
        locationStatusMessage = 'Permission de localisation refusée.';
        isLoadingLocation = false;
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        locationStatusMessage = 'Localisation récupérée';
        isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        locationStatusMessage = 'Impossible d\'obtenir la position.';
        isLoadingLocation = false;
      });
    }
  }

  void _validerFormulaire() async {
    if (_formKey.currentState!.validate()) {
      if (latitude == null || longitude == null) {
        setState(() {
          locationStatusMessage =
          'Veuillez récupérer votre position avant de continuer.';
        });
        return;
      }
      _formKey.currentState!.save();

      Projet nouveauProjet = Projet(
        titre: nom,
        description: description,
        latitude: latitude!,
        longitude: longitude!,
      );

      Navigator.pop(context, nouveauProjet);
    }
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ajouter un projet')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: (value) =>
                  value == null || value.isEmpty
                      ? 'Champ requis'
                      : null,
                  onSaved: (value) => nom = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) =>
                  value == null || value.isEmpty
                      ? 'Champ requis'
                      : null,
                  onSaved: (value) => description = value!,
                ),
                const SizedBox(height: 20),

                // Affichage du statut de localisation
                if (isLoadingLocation) ...[
                  Row(
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(width: 10),
                      Text('Récupération de la localisation...',
                          style: TextStyle(color: Colors.green)),
                    ],
                  ),
                ] else
                  if (locationStatusMessage.isNotEmpty) ...[
                    Text(locationStatusMessage,
                        style: TextStyle(color: Colors.red)),
                  ],

                const SizedBox(height: 10),

                // Bouton pour rafraîchir la position manuellement
                ElevatedButton.icon(
                  onPressed: isLoadingLocation ? null : _getLocation,
                  icon: const Icon(Icons.my_location),
                  label: const Text('Rafraîchir la position'),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: isLoadingLocation ? null : _validerFormulaire,
                  child: const Text('Ajouter'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

