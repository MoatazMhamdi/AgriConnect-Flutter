import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/User.dart'; // Importer le modèle User

class EquipmentUserService {
  static const String apiUrl = 'http://localhost:9090/users/AllUser';
  List<User> userList = [];

  final _userStreamController = StreamController<List<User>>.broadcast();

  Future<void> fetchUserList() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Received user data: $data');

        // Convertir la liste dynamique en une liste d'objets User
        List<User> fetchedUserList = data.map((item) => User.fromJson(item)).toList();

        // Filtrer la liste pour n'inclure que les utilisateurs avec le rôle Farmer ou Client
        userList = fetchedUserList.where((user) => user.role == 'Farmer' || user.role == 'Client').toList();

        _notifyListeners();

        print('Filtered user list successfully loaded. User list fetched successfully: ${userList.length} users');
      } else {
        print('Failed to load user list. Status code: ${response.statusCode}');
        throw Exception('Failed to load user list');
      }
    } catch (e) {
      print('Error fetching user list: $e');
      throw Exception('Failed to load user list');
    }
  }

  List<User> get userlist => userList;

  Stream<List<User>> get userStream => _userStreamController.stream;

  void _notifyListeners() {
    _userStreamController.add(userList);
  }

  void dispose() {
    _userStreamController.close();
  }
}
