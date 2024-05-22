import 'package:http/http.dart' as http;
import 'package:project_pal/core/app_export.dart';

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
        patronymic: data['patronymic'], login: '', phoneNumber: '', newPassword: '',
      );
    } else {
      throw Exception('Failed to verify temporary user');
    }
  }

  Future<String> login(String login, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'login': login, 'password': password}),
    );

    print("API response status: ${response.statusCode}");
    print("API response body: ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<User> registerUser(int id, String login, String phoneNumber, String newPassword) async {
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
      final data = jsonDecode(response.body);
      return User(
        id: data['id'],
        login: data['login'],
        phoneNumber: data['phoneNumber'],
        newPassword: data['newPassword'], name: '', surname: '', patronymic: '',
      );
    } else {
      throw Exception('Failed to register user');
    }
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

  User({required this.id, required this.name, required this.surname, required this.patronymic, required this.login, required this.phoneNumber, required this.newPassword});
}
