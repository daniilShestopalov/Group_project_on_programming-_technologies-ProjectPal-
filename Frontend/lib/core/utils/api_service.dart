import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_pal/core/app_export.dart';
import 'package:http_parser/http_parser.dart';
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
    print(
        "Token from storage: $token"); // Добавьте эту строку для вывода значения токена
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

      if (authorizationHeader != null &&
          authorizationHeader.startsWith('Bearer ')) {
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
          avatarLink: data['avatarLink'],
          role: '',
        );
      } else {
        throw Exception('Failed to extract token from authorization header');
      }
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> registerUser(
      int id, String login, String phoneNumber, String newPassword) async {
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

  Future<Group> getGroupById(String token, int groupId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/group/$groupId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final utf8Body =
          utf8.decode(response.bodyBytes); // Явное декодирование в UTF-8
      final groupData = json.decode(utf8Body);
      return Group.fromJson(groupData);
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

  Future<void> updateUserAvatar(
      String token, int userId, String newAvatarLink) async {
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

      // Добавление заголовка авторизации
      request.headers['Authorization'] = 'Bearer $token';

      // Определение MIME-типа файла
      final mimeType = lookupMimeType(imageFile.path);
      if (mimeType == null) {
        print('Could not determine MIME type of the file');
        return;
      }

      // Отладочные сообщения
      print('Image file path: ${imageFile.path}');
      print('Image file MIME type: $mimeType');

      // Добавление файла
      final file = await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType.parse(mimeType),
      );
      request.files.add(file);

      var response = await request.send();

      // Проверка статус кода ответа
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('File uploaded successfully: $responseBody');
      } else if (response.statusCode == 415) {
        print('Only image files are allowed for avatars');
      } else if (response.statusCode == 413) {
        print('File size must be less than 2MB');
      } else {
        print('Image upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  Future<File?> downloadAvatar(String token, String filename) async {
    String url = '$baseUrl/file/download/avatar/$filename';

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        Directory tempDir = await getTemporaryDirectory();
        File file = File('${tempDir.path}/$filename');
        await file.writeAsBytes(response.bodyBytes);
        print('Avatar saved successfully: ${file.path}');
        return file;
      } else {
        // Handle other status codes if needed
        print('Failed to download avatar. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error downloading avatar: $e');
      return null;
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

      if (response.statusCode == 200) {
        final utf8Body =
            utf8.decode(response.bodyBytes); // Явное декодирование в UTF-8
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
      final utf8Body =
          utf8.decode(response.bodyBytes); // Явное декодирование в UTF-8
      final List<dynamic> data = jsonDecode(utf8Body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users by group');
    }
  }

  Future<Tasks> getTaskById(String token, int taskId) async {
    try {
      final Uri url = Uri.parse('$baseUrl/task/$taskId');
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
        final utf8Body =
            utf8.decode(response.bodyBytes); // Явное декодирование в UTF-8
        final TasksData = json.decode(utf8Body);
        return Tasks.fromJson(TasksData);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Error: $e');
    }
  }

  Future<List<Tasks>> getTasksByMonthAndGroup(
      int groupId, int year, int month, String token) async {
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
          'Content-Type':
              'application/json', // Устанавливаем тип контента как JSON
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

  Future<List<Tasks>> getTasksByDayAndGroup(
      int groupId, DateTime date, String token) async {
    final url = Uri.parse('$baseUrl/task/group/date');
    final Map<String, dynamic> requestBody = {
      'id': groupId,
      'date': date
          .toIso8601String(), // Преобразуем дату в строку в формате ISO 8601
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type':
              'application/json', // Устанавливаем тип контента как JSON
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

  Future<List<Tasks>> getTasksByGroupId(String token, int groupId) async {
    try {
      final Uri url = Uri.parse('$baseUrl/task/group/$groupId');
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
        final List<dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes)); // Декодирование UTF-8
        return data.map((json) => Tasks.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Error: $e');
    }
  }

  Future<List<Tasks>> getTasksByTeacherId(String token, int teacherId) async {
    try {
      final Uri url = Uri.parse('$baseUrl/task/teacher/$teacherId');
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
        final List<dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes)); // Декодирование UTF-8
        return data.map((json) => Tasks.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Error: $e');
    }
  }

  Future<List<Project>> getStudentProjectByUserId(
      String token, int studentId) async {
    try {
      final Uri url = Uri.parse('$baseUrl/student-project/projects/$studentId');
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
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((json) => Project.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Error: $e');
    }
  }

  Future<List<Project>> getProjectsByStudentProjectId(
      String token, int id) async {
    try {
      final Uri url = Uri.parse('$baseUrl/project/$id');
      print('Request URL: $url');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print('22222');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((json) => Project.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('вторая не пошла');
      print('Exception: $e');
      throw Exception('Error: $e');
    }
  }

  Future<int> getTasksCountByGroup(int groupId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/task/group/$groupId/count'),
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

  Future<int> getProjectCountByUserId(int studentId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/project/student/$studentId/count'),
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

  Future<List<User>> getUsersByRole(String role, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/role/$role'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final utf8Body =
          utf8.decode(response.bodyBytes); // Явное декодирование в UTF-8
      final List<dynamic> data = jsonDecode(utf8Body);
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

  Future<String?> downloadTaskAnswer(String token, int id, String filename) async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/file/download/task-answer/$id/$filename'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Получаем путь для сохранения файла на устройстве
        String dir = (await getExternalStorageDirectory())!.path;
        String filePath = '$dir/$filename';

        // Создаем файл и записываем в него данные из ответа
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        print('Файл успешно скачан: $filePath');
        return filePath;
      } else {
        // Обработка ошибок
        print('Ошибка: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Ошибка при выполнении запроса: $e');
      return null;
    }
  }

  Future<String?> downloadTaskFile(String token, int id, String filename) async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/file/download/task/$id/$filename'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        String dir = (await getExternalStorageDirectory())!.path;
        String filePath = '$dir/$filename';

        // Создаем файл и записываем в него данные из ответа
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        print('Файл успешно скачан: $filePath');
        return filePath;
      } else {
        // Обработка ошибок
        print('Ошибка: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Ошибка при выполнении запроса: $e');
      return null;
    }
  }

  Future<void> updateTaskAnswer({
    required String token,
    required int id,
    required int taskId,
    required int studentUserId,
    required String submissionDate,
    required String teacherCommentary,
    required int grade,
    required String fileLink,
  }) async {
    final String url = '$baseUrl/task-answer';

    Map<String, dynamic> requestBody = {
      "id": id,
      "taskId": taskId,
      "studentUserId": studentUserId,
      "submissionDate": submissionDate,
      "teacherCommentary": teacherCommentary,
      "studentCommentary": '',
      "grade": grade,
      "fileLink": fileLink,
    };

    print('Request URL: $url');
    print('Request Body: ${jsonEncode(requestBody)}');

    try {
      final http.Response response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Task answer updated successfully');
      } else {
        print(
            'Failed to update task answer. Error ${response.statusCode}: ${response.reasonPhrase}');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      print('Failed to update task answer: $e');
    }
  }

  Future<Map<String, dynamic>> getTaskAnswerById(String token, int id) async {
    try {
      final Uri url = Uri.parse('$baseUrl/task-answer/$id');
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
        return jsonDecode(utf8.decode(response.bodyBytes))
            as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load task answer');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getTaskAnswerByTaskId(
      String token, int taskId) async {
    try {
      final Uri url = Uri.parse('$baseUrl/task-answer/task/$taskId');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));

        if (jsonResponse != null && jsonResponse is List) {
          final List<Map<String, dynamic>> data =
              jsonResponse.cast<Map<String, dynamic>>();
          return data;
        } else {
          throw Exception('Failed to decode task answer data');
        }
      } else {
        print(
            'Failed to load task answer. Status code: ${response.statusCode}');
        throw Exception(
            'Failed to load task answer. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getProjectAnswerByProjectId(
      String token, int projectId) async {
    try {
      final Uri url = Uri.parse('$baseUrl/project-answer/project/$projectId');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        return jsonResponse;
      } else {
        print(
            'Failed to load task answer. Status code: ${response.statusCode}');
        throw Exception(
            'Failed to load task answer. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch project answer: $e');
    }
  }

  Future<void> uploadTaskAnswerFile(String token, File pdfFile) async {
    try {
      final apiUrl = '$baseUrl/file/upload/task-answer';
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Добавление заголовка авторизации
      request.headers['Authorization'] = 'Bearer $token';

      // Определение MIME-типа файла (PDF)
      final mimeType = 'application/pdf';

      // Отладочные сообщения
      print('PDF file path: ${pdfFile.path}');
      print('PDF file MIME type: $mimeType');

      // Добавление файла
      final file = await http.MultipartFile.fromPath(
        'file',
        pdfFile.path,
        contentType: MediaType.parse(mimeType),
      );
      request.files.add(file);

      var response = await request.send();

      // Проверка статус кода ответа
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('File uploaded successfully: $responseBody');
      } else if (response.statusCode == 415) {
        print('Only PDF files are allowed for task answers');
      } else {
        print('File upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  Future<void> uploadTaskFile(String token, File pdfFile, int taskId) async {
    try {
      final apiUrl = '$baseUrl/file/upload/task?id=$taskId';
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Добавление заголовка авторизации
      request.headers['Authorization'] = 'Bearer $token';

      // Определение MIME-типа файла (PDF)
      final mimeType = 'application/pdf';

      // Отладочные сообщения
      print('PDF file path: ${pdfFile.path}');
      print('PDF file MIME type: $mimeType');

      // Добавление файла
      final file = await http.MultipartFile.fromPath(
        'file',
        pdfFile.path,
        contentType: MediaType.parse(mimeType),
      );
      request.files.add(file);

      var response = await request.send();

      // Проверка статус кода ответа
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('File uploaded successfully: $responseBody');
      } else if (response.statusCode == 415) {
        print('Only PDF files are allowed for task answers');
      } else {
        print('File upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }


  Future<void> updateUserWithoutPassword({
    required int id,
    required String login,
    required String name,
    required String surname,
    required String patronymic,
    required String phoneNumber,
    required String avatarLink,
    required String role,
    required int groupId,
    required String token,
  }) async {
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

  Future<void> updateTask({
    required String token,
    required int taskId,
    required String name,
    required int teacherUserId,
    required int groupId,
    required String description,
    required String fileLink,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final String url = '$baseUrl/task';

    Map<String, dynamic> requestBody = {
      "id": taskId,
      "name": name,
      "teacherUserId": teacherUserId,
      "groupId": groupId,
      "description": description,
      "fileLink": fileLink,
      "startDate": startDate.toIso8601String(),
      "endDate": endDate.toIso8601String()
    };

    print('Request URL: $url');
    print('Request Body: ${jsonEncode(requestBody)}');

    try {
      final http.Response response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Task updated successfully');
      } else {
        print(
            'Failed to update task. Error ${response.statusCode}: ${response.reasonPhrase}');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      print('Failed to update task answer: $e');
    }
  }

  Future<int?> createTask({
    required String token,
    required int taskId,
    required String name,
    required int teacherUserId,
    required int groupId,
    required String description,
    required String fileLink,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final String url = '$baseUrl/task';

    Map<String, dynamic> requestBody = {
      "id": taskId,
      "name": name,
      "teacherUserId": teacherUserId,
      "groupId": groupId,
      "description": description,
      "fileLink": fileLink,
      "startDate": startDate.toIso8601String(),
      "endDate": endDate.toIso8601String()
    };

    print('Request URL: $url');
    print('Request Body: ${jsonEncode(requestBody)}');

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        print('Task created successfully');
        try {
          Map<String, dynamic> responseBody = jsonDecode(response.body);
          int newTaskId = responseBody['id'];
          print(newTaskId);// Предполагаем, что id возвращается в поле 'id'
          return newTaskId;
        } catch (e) {
          print('Failed to parse response body: $e');
        }
      } else {
        print(
            'Failed to create task. Error ${response.statusCode}: ${response.reasonPhrase}');
        // Попробуйте распарсить тело ответа, если это JSON, для получения дополнительной информации об ошибке
        try {
          Map<String, dynamic> responseBody = jsonDecode(response.body);
          print('Detailed Error Message: ${responseBody['message']}');
        } catch (e) {
          print('Failed to parse error message: $e');
        }
      }
    } catch (e) {
      print('Failed to create task: $e');
    }
  }

  Future<void> createTaskAnswer({
    required String token,
    required int taskId,
    required int id,
    required int studentUserId,
    required DateTime submissionDate,
    required String teacherCommentary,
    required String studentCommentary,
    required int grade,
    required String fileLink,
  }) async {
    final String url = '$baseUrl/task-answer';

    Map<String, dynamic> requestBody = {
    'id': id,
    'taskId': taskId,
    'studentUserId': studentUserId,
    'submissionDate': submissionDate.toIso8601String(),
    'teacherCommentary': teacherCommentary,
    'studentCommentary': studentCommentary,
    'grade': grade,
    'fileLink': fileLink
    };

    print('Request URL: $url');
    print('Request Body: ${jsonEncode(requestBody)}');

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('Task Answer created successfully');
      } else {
        print(
            'Failed to create task. Error ${response.statusCode}: ${response.reasonPhrase}');
        // Попробуйте распарсить тело ответа, если это JSON, для получения дополнительной информации об ошибке
        try {
          Map<String, dynamic> responseBody = jsonDecode(response.body);
          print('Detailed Error Message: ${responseBody['message']}');
        } catch (e) {
          print('Failed to parse error message: $e');
        }
      }
    } catch (e) {
      print('Failed to create task: $e');
    }
  }

  Future<void> deleteTask({
    required String token,
    required int taskId,
  }) async {
    final String url = '$baseUrl/task/$taskId';

    try {
      final http.Response response = await http.delete(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Task with ID $taskId deleted successfully');
      } else {
        print(
            'Failed to delete task. Error ${response.statusCode}: ${response.reasonPhrase}');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      print('Failed to delete task: $e');
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
  }) : _countOfPeople = countOfPeople;

  int get countOfPeople => _countOfPeople; // Геттер для countOfPeople

  set countOfPeople(int value) =>
      _countOfPeople = value; // Сеттер для countOfPeople

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

class Project {
  final int id; // обязательное поле
  final String name; // обязательное поле
  final int teacherUserId; // обязательное поле
  final String? description; // nullable поле
  final String fileLink; // обязательное поле
  final DateTime startDate; // обязательное поле
  final DateTime? endDate; // nullable поле

  Project({
    required this.id,
    required this.name,
    required this.teacherUserId,
    this.description, // nullable
    required this.fileLink,
    required this.startDate,
    this.endDate, // nullable
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      teacherUserId: json['teacherUserId'],
      description: json['description'],
      fileLink: json['fileLink'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }
}

class StudentProject {
  final int id;
  final int studentUserId;
  final int projectId;

  StudentProject({
    required this.id,
    required this.studentUserId,
    required this.projectId,
  });

  factory StudentProject.fromJson(Map<String, dynamic> json) {
    return StudentProject(
      id: json['id'],
      studentUserId: json['studentUserId'],
      projectId: json['projectId'],
    );
  }
}

class ProjectAnswer {
  final int id;
  final int projectId;
  final DateTime submissionDate;
  final String teacherCommentary;
  final String studentCommentary;
  final int grade;
  final String fileLink;

  ProjectAnswer({
    required this.id,
    required this.projectId,
    required this.submissionDate,
    required this.teacherCommentary,
    required this.studentCommentary,
    required this.grade,
    required this.fileLink,
  });

  factory ProjectAnswer.fromJson(Map<String, dynamic> json) {
    return ProjectAnswer(
      id: json['id'],
      projectId: json['projectId'],
      submissionDate: DateTime.parse(json['submissionDate']),
      teacherCommentary: json['teacherCommentary'],
      studentCommentary: json['studentCommentary'],
      grade: json['grade'],
      fileLink: json['fileLink'],
    );
  }
}
