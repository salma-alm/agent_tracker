import 'package:flutter/material.dart';
import '../models/Visit.dart';
import '../services/api_service.dart';

class AddVisit extends StatefulWidget{
  final int projectId;
  const AddVisit({super.key, required this.projectId});

  @override
  State<AddVisit> createState() => _AddVisitState();
}

class _AddVisitState extends State<AddVisit> {
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  late String note;
  bool isLoading = false;

  Future<void> _validerFormulaire() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Visit nouvelleVisite = Visit(
        projetId: widget.projectId,
        date: selectedDate,
        remarque: note,
      );

      setState(() => isLoading = true);

      try {
        Visit visiteEnregistree = await ApiService().createVisit(nouvelleVisite);
        Navigator.pop(context, visiteEnregistree); // Retourne la visite à la page précédente
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : ${e.toString()}')),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une visite'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("Date de la visite : ${selectedDate.toLocal()}".split(' ')[0]),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() => selectedDate = picked);
                  }
                },
                child: const Text('Choisir la date'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Remarque',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Veuillez entrer une remarque'
                    : null,
                onSaved: (value) => note = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _validerFormulaire,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Valider'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}