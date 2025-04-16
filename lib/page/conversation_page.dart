import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/user_preferences.dart';

class ConversationPage extends StatefulWidget {
  final String friendEmail;
  final String conversationId;
  final bool isDarkMode;

  const ConversationPage({
    required this.friendEmail,
    required this.conversationId,
    required this.isDarkMode,
  });

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  String userId = "";

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      final token = await UserPreferences.getUserToken();
      final currentUserId = await UserPreferences.getUserId();

      if (token != null && currentUserId != null) {
        userId = currentUserId;
        final fetchedMessages = await ApiService.getConversationMessages(widget.conversationId, token);

        print("Fetched messages: $fetchedMessages");

        setState(() {
          messages = fetchedMessages;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading messages: $e")),
      );
    }
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    try {
      final token = await UserPreferences.getUserToken();
      if (token != null) {
        await ApiService.sendMessage(widget.conversationId, userId, content, token);
        _messageController.clear();
        _loadMessages(); // Refresh messages
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending message: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: widget.isDarkMode ? Colors.grey[900] : Colors.green,
        title: Text(
          widget.friendEmail,
          style: TextStyle(
            color: widget.isDarkMode ? Colors.white : Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: widget.isDarkMode ? Colors.white : Colors.white,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Text(
                      "No messages yet.",
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[messages.length - 1 - index];
                      final isMe = message['iduser'] == userId;

                      return Container(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isMe
                                ? (widget.isDarkMode ? Colors.green[800] : Colors.green[400])
                                : (widget.isDarkMode ? Colors.grey[700] : Colors.grey[300]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Text(
                            message['contenu'] ?? '',
                            style: TextStyle(
                              color: widget.isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      hintStyle: TextStyle(
                        color: widget.isDarkMode ? Colors.white54 : Colors.black45,
                      ),
                      filled: true,
                      fillColor: widget.isDarkMode ? Colors.grey[850] : Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: widget.isDarkMode ? Colors.greenAccent : Colors.green),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
