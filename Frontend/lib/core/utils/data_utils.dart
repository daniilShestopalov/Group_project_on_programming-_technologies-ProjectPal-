import 'package:project_pal/core/app_export.dart';
import 'package:collection/collection.dart';

class DataUtils {

  static List<Map<String, dynamic>> getTeachersData() {
    List<Map<String, dynamic>> usersData = MockData.usersData;
    List<Map<String, dynamic>> teachersData = [];

    for (var userData in usersData) {
      if (userData['role'] == 'professor') {
        teachersData.add(userData);
      }
    }

    return teachersData;
  }

  static List<Map<String, dynamic>> getTasksData() {
    return MockData.tasksData;
  }

  static String getTeacherNameById(int teacherId) {
    // Получаем список всех пользователей
    List<Map<String, dynamic>> usersData = getTeachersData();

    // Находим преподавателя по его идентификатору
    Map<String, dynamic>? teacherData = usersData.firstWhereOrNull((userData) => userData['id'] == teacherId);

    if (teacherData != null) {
      // Формируем ФИО преподавателя
      String teacherName = '${teacherData['surname']} ${teacherData['name']} ${teacherData['patronymic']}';
      return teacherName;
    } else {
      return ''; // Возвращаем пустую строку в случае отсутствия преподавателя
    }
  }

  bool validateCredentials(String login, String password) {
    // Проверяем, есть ли введенный login в списке пользователей
    Map<String, dynamic>? userData = MockData.usersData.firstWhere((user) => user['login'] == login, orElse: () => {});

    if (userData.isNotEmpty) {
      // Если найден пользователь с таким login, проверяем пароль
      if (userData['password'] == password) {
        // Пароль верный
        return true;
      } else {
        // Неверный пароль
        return false;
      }
    } else {
      // Пользователь с таким login не найден
      return false;
    }
  }

  static String getUserRoleById(int userId) {
    // Ищем пользователя с заданным ID
    Map<String, dynamic>? user = MockData.usersData.firstWhere((user) => user['id'] == userId, orElse: () => {});
    return user['role'];
  }

  static String getRoleName(String role) {
    String roleName;

    // Преобразуем роль в соответствующее название
    switch (role) {
      case 'student':
        roleName = 'Студент';
        break;
      case 'professor':
        roleName = 'Преподаватель';
        break;
      case 'admin':
        roleName = 'Администратор';
        break;
      default:
        roleName = 'Роль не определена';
        break;
    }

    return roleName;
  }

  static String getUserFullNameById(int userId) {
    // Находим пользователя по его ID в списке пользователей
    var user = MockData.usersData.firstWhere((user) => user['id'] == userId);

    // Получаем информацию о пользователе
    String fullName = '${user['surname']} ${user['name']} ${user['patronymic']}';
    // String role = user['role'];

    // Возвращаем информацию о пользователе в виде Map
    return fullName;
    // 'role': role,
  }

  static String getUserNameById(int userId) {
    // Ищем пользователя с заданным ID
    Map<String, dynamic>? user = MockData.usersData.firstWhere((user) => user['id'] == userId, orElse: () => {});

    if (user.isNotEmpty) {
      // Возвращаем роль пользователя
      return user['name'];
    } else {
      // Если пользователь не найден, возвращаем пустую строку
      return '';
    }
  }

  static String getUserSurnameById(int userId) {
    // Ищем пользователя с заданным ID
    Map<String, dynamic>? user = MockData.usersData.firstWhere((user) => user['id'] == userId, orElse: () => {});

    if (user.isNotEmpty) {
      // Возвращаем роль пользователя
      return user['surname'];
    } else {
      // Если пользователь не найден, возвращаем пустую строку
      return '';
    }
  }

  static String getUserPatronymicById(int userId) {
    // Ищем пользователя с заданным ID
    Map<String, dynamic>? user = MockData.usersData.firstWhere((user) => user['id'] == userId, orElse: () => {});

    if (user.isNotEmpty) {
      // Возвращаем роль пользователя
      return user['patronymic'];
    } else {
      // Если пользователь не найден, возвращаем пустую строку
      return '';
    }
  }

  static String getUserEmailById(int userId) {
    // Ищем пользователя с заданным ID
    Map<String, dynamic>? user = MockData.usersData.firstWhere((user) => user['id'] == userId, orElse: () => {});

    if (user.isNotEmpty) {
      // Возвращаем роль пользователя
      return user['email'];
    } else {
      // Если пользователь не найден, возвращаем пустую строку
      return '';
    }
  }

  static String getUserGroupIdById(int userId) {
    Map<String, dynamic>? user = MockData.usersData.firstWhere((user) => user['id'] == userId, orElse: () => {});

    return user['groupId'];

  }

  static List<Map<String, dynamic>> getTasksByDate(DateTime date) {
    return MockData.tasksData.where((task) => task['endDate'].year == date.year && task['endDate'].month == date.month && task['endDate'].day == date.day).toList();
  }

  static String getUserInitialsById(int userId) {
    // Находим пользователя с заданным ID
    Map<String, dynamic>? user = MockData.usersData.firstWhere(
          (user) => user['id'] == userId,
      orElse: () => {},
    );

      String name = user['name'];
      String surname = user['surname'];

      String initials = '${surname.substring(0, 1)}${name.substring(0, 1)}';

      // Возвращаем их в верхнем регистре
      return initials.toUpperCase();

  }

  static Map<String, int> countUsersInGroups(List<Map<String, dynamic>> usersData) {
    Map<String, int> groupCounts = {};

    for (var user in usersData) {
      String groupId = user['groupId'].toString();
      if (groupId.isNotEmpty) {
        if (groupCounts.containsKey(groupId)) {
          groupCounts[groupId] = groupCounts[groupId]! + 1;
        } else {
          groupCounts[groupId] = 1;
        }
      }
    }

    return groupCounts;
  }

  static List<int> getUserIdsByGroupNumber(List<Map<String, dynamic>> usersData, String groupNumber) {
    List<int> userIds = [];
    for (var user in usersData) {
      if (user['groupId'] == groupNumber && user['role'] == 'student') {
        userIds.add(user['id']);
      }
    }
    return userIds;
  }

  static List<int> getTeacherIds() {
    // Получаем список всех пользователей
    List<Map<String, dynamic>> usersData = MockData.usersData;
    // Фильтруем пользователей, оставляя только преподавателей
    List<Map<String, dynamic>> teachersData = usersData.where((user) => user['role'] == 'professor').toList();
    // Получаем идентификаторы преподавателей
    List<int> teacherIds = teachersData.map<int>((teacher) => teacher['id']).toList();
    return teacherIds;
  }

}
