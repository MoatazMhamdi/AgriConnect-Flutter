import 'package:flutter/material.dart';
import '../../models/getUser.dart';
import '../../services/BanService.dart';
import '../../services/getAllUsers.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<Users> futureUser;
  bool isUserBanned = false; // Flag to track user ban status
  bool isUserUnBanned = false;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    futureUser = AuthSer.getAllUsers();
  }

  Future<void> banUser(String userId) async {
    try {
      // Wait for the future to complete
      Users users = await futureUser;

      // Show a confirmation dialog
      bool confirmBan = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Ban'),
            content: Text('Are you sure you want to ban this user?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // User confirmed ban
                },
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // User canceled ban
                },
                child: Text('No'),
              ),
            ],
          );
        },
      );

      // If user confirmed ban, send a request to ban the user
      if (confirmBan == true) {
        // Fetch the updated user after banning
        User updatedUser = await AuthService.banUser(userId);
        print('user banned successfully');

        // Set the flag to true if the user is banned
        setState(() {
          isUserBanned = true;
        });

        // Update the widget state with the latest user list
        setState(() {
          // Find the index of the banned user in the list
          int index = users.users.indexWhere((user) => user.id == updatedUser.id);
          // Update the user in the list with the banned status
          users.users[index] = updatedUser;
        });
      }
    } catch (error) {
      print('Failed to ban user: $error');
      // Handle error, show a snackbar, etc.
    }
  }

  Future<void> unbanUser(String userId) async {
    try {
      // Wait for the future to complete
      Users users = await futureUser;

      // Show a confirmation dialog
      bool confirmBan = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm UnBan'),
            content: Text('Are you sure you want to UnBan this user?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // User confirmed unban
                },
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // User canceled unban
                },
                child: Text('No'),
              ),
            ],
          );
        },
      );

      // If user confirmed unban, send a request to unban the user
      if (confirmBan == true) {
        // Fetch the updated user after unbanning
        User updatedUser = await AuthService.unbanUser(userId);
        print('user unbanned successfully');

        // Set the flag to true if the user is unbanned
        setState(() {
          isUserUnBanned = true;
        });

        // Update the widget state with the latest user list
        setState(() {
          // Find the index of the unbanned user in the list
          int index = users.users.indexWhere((user) => user.id == updatedUser.id);
          // Update the user in the list with the unbanned status
          users.users[index] = updatedUser;
        });
      }
    } catch (error) {
      print('Failed to unban user: $error');
      // Handle error, show a snackbar, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Screen'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  style: TextStyle(color: Colors.grey), // Set the text color
                  decoration: InputDecoration(
                    hintText: 'Search by Name',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<Users>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  Users users = snapshot.data!;
                  // Filter the users based on the search query
                  List<User> filteredUsers = users.users.where((user) {
                    return user.name?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false;
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      User user = filteredUsers[index];
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            margin: EdgeInsets.all(10.0),
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'User ID: ${user.id ?? "N/A"}',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  'Name: ${user.name ?? "N/A"}',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  'Email: ${user.email ?? "N/A"}',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  'Phone Number: ${user.numTel ?? "N/A"}',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  'Role: ${user.role ?? "N/A"}',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  user.isBanned == true ? 'User Banned' : 'User Unbanned',
                                  style: TextStyle(
                                    color: user.isBanned == true ? Colors.red : Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        banUser(user.id!); // Pass user ID to banUser function
                                      },
                                      child: Text('Ban'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        unbanUser(user.id!);
                                      },
                                      child: Text('Unban'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
