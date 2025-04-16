import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:5000";

  // ✅ Add a new user (register)
  static Future<void> addUser(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/add_user'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': userData['fullName'],
          'email': userData['email'],
          'password': userData['password'],
        }),
      );

      if (response.statusCode != 201) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to add user');
      }
    } catch (e) {
      throw Exception("Failed to add user: $e");
    }
  }

  // ✅ Sign in (login)
  static Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Invalid email or password');
      }
    } catch (e) {
      throw Exception("Failed to sign in: $e");
    }
  }

  // ✅ Get user profile by ID
  static Future<Map<String, dynamic>> getUserProfile(String userId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to get user profile');
      }
    } catch (e) {
      throw Exception("Failed to get user profile: $e");
    }
  }

  // ✅ Add a friend
  static Future<void> addFriend(String userId, String friendEmail, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/add_friend'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user1_id': userId,
          'friend_email': friendEmail,
        }),
      );

      if (response.statusCode != 201) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to add friend');
      }
    } catch (e) {
      throw Exception("Failed to add friend: $e");
    }
  }

  // ✅ Fetch conversation messages
  static Future<List<Map<String, dynamic>>> getConversationMessages(String conversationId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/conversations/$conversationId/messages'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to load messages');
      }
    } catch (e) {
      throw Exception("Failed to load messages: $e");
    }
  }

  // ✅ Send a new message
  static Future<void> sendMessage(String conversationId, String userId, String content, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/messages/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'conversationId': conversationId,
          'userId': userId,
          'content': content,
        }),
      );

      if (response.statusCode != 201) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to send message');
      }
    } catch (e) {
      throw Exception("Failed to send message: $e");
    }
  }

  // ✅ Get user profile by email
  static Future<Map<String, dynamic>> getUserProfileByEmail(String email, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/profile?email=$email'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to get user profile by email');
      }
    } catch (e) {
      throw Exception("Failed to get user profile by email: $e");
    }
  }

  // ✅ Fetch list of friends for the authenticated user
  static Future<List<Map<String, dynamic>>> getUserFriends(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/friends'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to fetch friends list');
      }
    } catch (e) {
      throw Exception("Failed to fetch friends: $e");
    }
  }

  // ✅ Get or create conversation ID
  static Future<String> getConversationId(String userId, String friendEmail, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/conversation?userId=$userId&friend=$friendEmail'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['conversationId'];
    } else {
      throw Exception('Failed to get conversation ID');
    }
  }
}
