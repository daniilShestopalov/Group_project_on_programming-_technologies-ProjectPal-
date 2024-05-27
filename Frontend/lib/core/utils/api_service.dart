
import 'dart:io';

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
        id: int.parse(data['id'].toString()),
        name: data['name'],
        surname: data['surname'],
        patronymic: data['patronymic'],
        login: data['login'],
        phoneNumber: data['phoneNumber'],
        newPassword: '',
        groupId: data['groupId'],
        avatarLink: data['avatarLink'],
        role: '',
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

  Future<int> getUserCountByGroup(int groupId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/group/$groupId/count'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user count');
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


  Future<void> uploadAvatar(String token, File imageFile) async {
    try {
      final apiUrl = '$baseUrl/file/upload/avatar';
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Чтение содержимого файла как массив байтов
      List<int> imageBytes = await imageFile.readAsBytes();

      // Кодирование массива байтов в base64 строку
      String base64Image = base64Encode(imageBytes);

      // Добавление base64 строки в параметры запроса
      request.fields['file'] = base64Image;

      // Добавление заголовка авторизации
      request.headers['Authorization'] = 'Bearer $token';

      // Отправка запроса
      var streamedResponse = await request.send();

      // Проверка статус кода ответа
      if (streamedResponse.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        print('Error uploading file');
      }
    } catch (e) {
      print('Error uploading file: $e');
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
        final utf8Body = utf8.decode(response.bodyBytes); // Явное декодирование в UTF-8
        final userData = json.decode(utf8Body);
        return User.fromJson(userData);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Error: $e');
    }
  }


  Future<List<User>> getUsersByGroup(int groupId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/group/$groupId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users by group');
    }
  }



  Future<List<Tasks>> getTasksByMonthAndGroup(int groupId, int year, int month, String token) async {
    final url = Uri.parse('$baseUrl/task/group/month');
    final Map<String, dynamic> requestBody = {
      'id': groupId,
      'yearMonth': "$year-0$month"
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Устанавливаем тип контента как JSON
        },
        body: jsonEncode(requestBody), // Кодируем тело запроса в JSON
      );

      if (response.statusCode == 200) {
        // Вывод тела ответа (весь список задач)
        print('Тело ответа в UTF-8:');
        print(utf8.decode(response.bodyBytes)); // Вывод в UTF-8

        List<dynamic> data = jsonDecode(response.body);
        return data.map((taskJson) => Tasks.fromJson(taskJson)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }


  Future<List<Tasks>> getTasksByDayAndGroup(int groupId, DateTime date, String token) async {
    final url = Uri.parse('$baseUrl/task/group/date');
    final Map<String, dynamic> requestBody = {
      'id': groupId,
      'date': date.toIso8601String(),
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Устанавливаем тип контента как JSON
        },
        body: jsonEncode(requestBody), // Кодируем тело запроса в JSON
      );

      if (response.statusCode == 200) {
        // Вывод тела ответа (весь список задач)
        print('Тело ответа в UTF-8:');
        print(utf8.decode(response.bodyBytes)); // Вывод в UTF-8

        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Tasks.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }


  Future<List<User>> getUsersByRole(String role, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/role/$role'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<User> users = [];

      // Преобразование данных в список объектов User
      for (var userData in data) {
        users.add(User.fromJson(userData));
      }

      return users;
    } else {
      throw Exception('Failed to load users by role');
    }
  }


  Future<void> updateUserWithoutPassword({required int id,
    required String login, required String name,
    required String surname, required String patronymic,
    required String phoneNumber, required String avatarLink,
    required String role, required int groupId,
    required String token,}) async {

    final data = jsonEncode(<String, dynamic>{
      'id': id,
      'login': login,
      'name': name,
      'surname': surname,
      'patronymic': patronymic,
      'phoneNumber': phoneNumber,
      'avatarLink': avatarLink,
      'role': role,
      'groupId': groupId,
    });

    print('Updating user'); // Debug print
    print('Data to be sent: $data');

    final response = await http.put(
      Uri.parse('$baseUrl/user/without-password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'login': login,
        'name': name,
        'surname': surname,
        'patronymic': patronymic,
        'phoneNumber': phoneNumber,
        'avatarLink': avatarLink,
        'role': role,
        'groupId': groupId,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}'); // Debug print

    if (response.statusCode == 200) {
      print('User updated successfully');
    } else {
      throw Exception('Failed to update user');
    }
  }



}


class Group {
  final int id;
  final int groupNumber;
  final int courseNumber;
  int _countOfPeople;

  Group({
    required this.id,
    required this.groupNumber,
    required this.courseNumber,
    int countOfPeople = 0,
  }) :_countOfPeople = countOfPeople;

  int get countOfPeople => _countOfPeople; // Геттер для countOfPeople

  set countOfPeople(int value) => _countOfPeople = value; // Сеттер для countOfPeople

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
  final String? newPassword;
  final int? groupId;
  final String role;
  final String avatarLink;

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.patronymic,
    required this.login,
    required this.phoneNumber,
    this.newPassword,
    this.groupId,
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
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'login': login,
      'password': newPassword,
      'name': name,
      'surname': surname,
      'patronymic': patronymic,
      'phoneNumber': phoneNumber,
      'avatarLink': avatarLink,
      'role': role,
      'groupId': groupId,
    };
  }
}

class Tasks {
  final int id;
  final String name;
  final int teacherUserId;
  final int groupId;
  final String description;
  final String fileLink;
  final DateTime startDate;
  final DateTime endDate;

  Tasks({
    required this.id,
    required this.name,
    required this.teacherUserId,
    required this.groupId,
    required this.description,
    required this.fileLink,
    required this.startDate,
    required this.endDate,
  });

  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
      id: json['id'],
      name: json['name'],
      teacherUserId: json['teacherUserId'],
      groupId: json['groupId'],
      description: json['description'],
      fileLink: json['fileLink'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
}
