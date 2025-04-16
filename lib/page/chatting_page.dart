import 'package:flutter/material.dart';
import 'package:personnemuette/page/add_friend_page.dart';
import 'conversation_page.dart';
import '../services/api_service.dart';
import '../utils/user_preferences.dart';

class ChattingPage extends StatefulWidget {
  @override
  _ChattingPageState createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  String userName = "Loading...";
  List<String> friends = [];
  List<String> filteredFriends = [];
  bool isDarkMode = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _searchController.addListener(_filterFriends);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final userId = await UserPreferences.getUserId();
      final token = await UserPreferences.getUserToken();
      if (userId != null && token != null) {
        final userProfile = await ApiService.getUserProfile(userId, token);
        setState(() {
          userName = userProfile['name'] ?? 'User';
          friends = List<String>.from(userProfile['friends'] ?? []);
          filteredFriends = friends;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    }
  }

  void _filterFriends() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredFriends = friends
          .where((friend) => friend.toLowerCase().contains(query))
          .toList();
    });
  }

  void _navigateToAddFriendScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddFriendPage(isDarkMode: isDarkMode),
      ),
    );
    _loadUserData();
  }

  void _toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey[200],
          title: Text(
            userName,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Navigator.canPop(context)
              ? IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.green),
                  onPressed: () => Navigator.pop(context),
                )
              : null,
          actions: [
            IconButton(
              icon: Icon(Icons.dark_mode, color: Colors.black),
              onPressed: _toggleDarkMode,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search friends...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(25),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFriends.length,
              itemBuilder: (context, index) {
                final friend = filteredFriends[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isDarkMode ? Colors.grey[700] : Colors.blue[100],
                    child: Text(
                      friend[0].toUpperCase(),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  title: Text(
                    friend,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  onTap: () async {
                    try {
                      final userId = await UserPreferences.getUserId();
                      final token = await UserPreferences.getUserToken();

                      if (userId != null && token != null) {
                        final conversationId = await ApiService.getConversationId(
                          userId,
                          friend,
                          token,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConversationPage(
                              friendEmail: friend,
                              conversationId: conversationId,
                              isDarkMode: isDarkMode,
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to load conversation: $e')),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddFriendScreen,
        child: Icon(Icons.person_add_alt_1_rounded),
        backgroundColor: isDarkMode ? Colors.green[800] : Colors.green[600],
        tooltip: "Add Friend",
      ),
    );
  }
}
