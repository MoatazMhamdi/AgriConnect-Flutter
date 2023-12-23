import 'package:flutter/material.dart';

import '../../models/User.dart';
import '../../services/EquipmentUserService.dart';
import 'equipment_user_screen.dart';

class MaintenanceScreen extends StatefulWidget {
  @override
  _MaintenanceScreenState createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  List<User> userList = [];
  final EquipmentUserService _userService = EquipmentUserService();

  @override
  void initState() {
    super.initState();
    _fetchUserList();
  }
  @override
  void dispose() {
    _userService.dispose();
    super.dispose();
  }
  Future<void> _fetchUserList() async {
    try {
      print('Fetching user list...');
      await _userService.fetchUserList();
      setState(() {
        userList = _userService.userList;
      });
      print('User list fetched successfully: ${userList.length} users');
    } catch (e) {
      print('Error fetching user list: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'List of Users',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            userList.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  User user = userList[index];
                  return _buildUserItem(user.id, user.name, user.email, user);
                },
              ),
            )
                : Text('No users available'),
          ],
        ),
      ),
    );
  }
  void _navigateToEquipmentUserScreen(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EquipmentUserScreen(user: user), // Use the provided user parameter
      ),
    );
  }
  Widget _buildUserItem(String id, String name, String email, User user) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(name),
        subtitle: Text(email),
        trailing: Text(id),
        onTap: () {
          _navigateToEquipmentUserScreen(user);
        },
      ),
    );
  }
}
