import 'package:flutter/material.dart';
import 'sign_in_page.dart';
import 'chatting_page.dart';
import 'statistics_page.dart';
import 'settings_page.dart';
import '../utils/user_preferences.dart'; // 👈 Assure-toi que ce fichier est bien importé

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String userName = "Loading...";
  bool isDarkMode = false;

  void _toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Log out"),
        content: Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();

              // 🔐 Supprimer les données utilisateur
              await UserPreferences.clearUserData();

              // 🔁 Rediriger vers la page de connexion
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  void _navigateToChatting() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChattingPage()),
    );
  }

  void _navigateToStatistics() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StatisticsPage()),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isDarkMode ? Colors.black : Colors.white;
    Color cardColor = isDarkMode ? Colors.grey[800]! : Colors.grey[100]!;
    Color iconColor = isDarkMode ? Colors.white : Colors.green[700]!;
    Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.green),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        title: Text(
          userName,
          style: TextStyle(color: textColor),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.dark_mode, color: Colors.green),
            onPressed: _toggleDarkMode,
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.redAccent),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16),
              children: [
                _buildMenuCard(
                  icon: Icons.chat,
                  label: "Chat",
                  onTap: _navigateToChatting,
                  iconColor: iconColor,
                  textColor: textColor,
                  cardColor: cardColor,
                ),
                _buildMenuCard(
                  icon: Icons.bar_chart,
                  label: "Statistics",
                  onTap: _navigateToStatistics,
                  iconColor: iconColor,
                  textColor: textColor,
                  cardColor: cardColor,
                ),
                _buildMenuCard(
                  icon: Icons.settings,
                  label: "Settings",
                  onTap: _navigateToSettings,
                  iconColor: iconColor,
                  textColor: textColor,
                  cardColor: cardColor,
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color iconColor,
    required Color textColor,
    required Color cardColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: iconColor),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
