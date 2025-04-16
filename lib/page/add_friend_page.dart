import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/user_preferences.dart';

class AddFriendPage extends StatefulWidget {
  final bool isDarkMode;

  const AddFriendPage({super.key, required this.isDarkMode});

  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  Future<void> _addFriend(BuildContext context) async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final token = await UserPreferences.getUserToken();
      final userId = await UserPreferences.getUserId();

      if (token != null && userId != null) {
        await ApiService.addFriend(userId, email, token);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Friend added successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add friend: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isDarkMode ? Colors.black : Colors.white;
    final appBarColor = Colors.grey[200]; // Gris clair
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final fieldColor = widget.isDarkMode ? Colors.grey[850] : Colors.grey[100];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          "Add New Friend",
          style: TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Friend's Email",
                labelStyle: TextStyle(color: textColor),
                prefixIcon: Icon(Icons.email, color: textColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                filled: true,
                fillColor: fieldColor,
              ),
              style: TextStyle(color: textColor),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: isLoading ? null : () => _addFriend(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Add Friend",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
