import 'package:http/http.dart' as http;
import 'package:project_pal/core/app_export.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = 'http://5.187.83.11:8080';

  Future<User> verifyTempUser(String tempLogin, String tempPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-temp-user'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'tempLogin': tempLogin, 'tempPassword': tempPassword}),
    );

    print("Verify Temp User response status: ${response.statusCode}");
    print("Verify Temp User response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User(
        id: data['id'],
        name: data['name'],
        surname: data['surname'],
        patronymic: data['patronymic'],
        login: data['login'],
        phoneNumber: data['phoneNumber'],
        newPassword: '',
        groupId: data['groupId'],
        avatarLink: data['avatarLink'], role: '',
      );
    } else {
      throw Exception('Failed to verify temporary user');
    }
  }

  final storage = new FlutterSecureStorage();

  Future<String?> getJwtToken() async {
    // Извлекаем токен из защищенного хранилища
    final token = await storage.read(key: 'jwt_token');
    print("Token from storage: $token"); // Добавьте эту строку для вывода значения токена
    return token;
  }

  Future<User> login(String login, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'login': login, 'password': password}),
    );

    print("API response status: ${response.statusCode}");
    print("API response body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final authorizationHeader = response.headers['authorization'];



      if (authorizationHeader != null && authorizationHeader.startsWith('Bearer ')) {
        final token = authorizationHeader.substring(7); // Удаляем "Bearer "
        print(token);

        // Сохраняем токен в защищенном хранилище
        await storage.write(key: 'jwt_token', value: token);
        return User(
          id: data['id'],
          name: data['name'],
          surname: data['surname'],
          patronymic: data['patronymic'],
          login: data['login'],
          phoneNumber: data['phoneNumber'],
          newPassword: '',
          groupId: data['groupId'],
          avatarLink: data['avatarLink'], role: '',
        );
      } else {
        throw Exception('Failed to extract token from authorization header');
      }
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> registerUser(int id, String login, String phoneNumber, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'id': id,
        'login': login,
        'phoneNumber': phoneNumber,
        'newPassword': newPassword,
      }),
    );

    print("Register User response status: ${response.statusCode}");
    print("Register User response body: ${response.body}");

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to register user');
    }
  }

  Future<void> sendPasswordResetCode(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/send-password-reset-code'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'email': email,
      }),
    );

    print("Send Password Reset Code response status: ${response.statusCode}");
    print("Send Password Reset Code response body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Failed to send password reset code');
    }
  }

  Future<List<Group>> fetchGroups(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/group'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Добавляем токен к заголовкам
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Group.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load groups');
    }
  }

  Future<void> updateUserAvatar(String token, int userId, String newAvatarLink) async {
    final Uri url = Uri.parse('$baseUrl/user/avatar');
    print(newAvatarLink);
    final Map<String, dynamic> requestBody = {
      'id': userId,
      'avatarLink': newAvatarLink,
    };

    final http.Response response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Avatar updated successfully');
      print(newAvatarLink);
    } else {
      print('Failed to update avatar');
    }
  }

  Future<User> getUserById(String token, int userId) async {
    try {
      final Uri url = Uri.parse('$baseUrl/user/$userId');
      print('Request URL: $url');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        return User.fromJson(userData);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Error: $e');
    }
  }



}


class Group {
  final int id;
  final int groupNumber;
  final int courseNumber;

  Group({
    required this.id,
    required this.groupNumber,
    required this.courseNumber,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      groupNumber: json['groupNumber'],
      courseNumber: json['courseNumber'],
    );
  }
}

class User {
  final int id;
  final String name;
  final String surname;
  final String patronymic;
  final String login;
  final String phoneNumber;
  final String newPassword;
  final int groupId;
  final String role;
  final String avatarLink;

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.patronymic,
    required this.login,
    required this.phoneNumber,
    required this.newPassword,
    required this.groupId,
    required this.role,
    required this.avatarLink,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      login: json['login'],
      name: json['name'],
      surname: json['surname'],
      patronymic: json['patronymic'],
      phoneNumber: json['phoneNumber'],
      avatarLink: json['avatarLink'],
      role: json['role'],
      groupId: json['groupId'],
      newPassword: '',
    );
  }
}
