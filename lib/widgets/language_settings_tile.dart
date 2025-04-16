import 'package:flutter/material.dart';

class LanguageSettingsTile extends StatefulWidget {
  const LanguageSettingsTile({super.key});

  @override
  _LanguageSettingsTileState createState() => _LanguageSettingsTileState();
}

class _LanguageSettingsTileState extends State<LanguageSettingsTile> {
  String _selectedLanguage = 'English'; // Langue par défaut

  // Liste des langues disponibles
  final List<String> _languages = ['English', 'Français', 'Español', 'Deutsch', 'العربية'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Language Settings"),
        backgroundColor: Colors.green[100], // Vert clair pour la barre
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Afficher un titre
            const Text(
              "Select your language:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Liste déroulante pour choisir la langue
            DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? newLanguage) {
                setState(() {
                  _selectedLanguage = newLanguage!;
                });
              },
              items: _languages
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            // Affichage de la langue sélectionnée
            Text(
              'Selected Language: $_selectedLanguage',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
