import 'package:flutter/material.dart';
import '../widgets/language_settings_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isNotificationsEnabled = true;

  // Fonction pour obtenir le nom de la langue
  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'fr':
        return 'Français';
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'de':
        return 'Deutsch';
      case 'ar':
        return 'العربية';
      default:
        return locale.languageCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer la langue actuelle
    final locale = Localizations.localeOf(context);
    final currentLanguage = getLanguageName(locale);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.green[100], // Vert clair pour la barre
        shadowColor: Colors.green[200], // Ombre encore plus claire
        elevation: 5, // Ombre légère
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFD0E8D0), // Vert très clair/gris-vert en haut
                const Color(0xFFE6E6E6), // Gris clair en bas
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Section des informations de compte
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  ListTile(
                    title: const Text("Change Password"),
                    leading: const Icon(Icons.lock, color: Colors.grey),
                    onTap: () {
                      // Action pour changer le mot de passe
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text("Privacy Settings"),
                    leading: const Icon(Icons.privacy_tip, color: Colors.grey),
                    onTap: () {
                      // Action pour accéder aux paramètres de confidentialité
                    },
                  ),
                ],
              ),
            ),

            // Section des notifications
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text("Enable Notifications"),
                    value: _isNotificationsEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        _isNotificationsEnabled = value;
                      });
                    },
                    secondary: const Icon(Icons.notifications, color: Colors.grey),
                    activeColor: Colors.grey,
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text("Notification Preferences"),
                    leading: const Icon(Icons.settings, color: Colors.grey),
                    onTap: () {
                      // Action pour modifier les préférences de notification
                    },
                  ),
                ],
              ),
            ),

            // Section des paramètres avancés
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  ListTile(
                    title: const Text("Change Theme"),
                    leading: const Icon(Icons.brightness_6, color: Colors.grey),
                    onTap: () {
                      // Action pour changer le thème
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text("Language Settings"),
                    leading: const Icon(Icons.language, color: Colors.grey),
                    onTap: () {
                      // Naviguer vers la page LanguageSettingsTile
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LanguageSettingsTile(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  // Affichage de la langue actuelle
                  ListTile(
                    title: Text("Current Language: $currentLanguage"),
                    leading: const Icon(Icons.translate, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Section avec des boutons d'actions
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Action pour enregistrer les paramètres
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700], // Vert foncé pour le bouton
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50), // Boutons ronds
                      ),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white, // Texte blanc
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      // Action pour annuler
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.grey[800], // Gris foncé pour le bouton
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50), // Boutons ronds
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white, // Texte blanc
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
