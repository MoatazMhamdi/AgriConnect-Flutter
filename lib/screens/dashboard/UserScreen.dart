import 'package:flutter/material.dart';
import '../../models/getUser.dart';
import '../../services/getAllUsers.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<Users> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = AuthSer.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Screen'),
      ),
      body: FutureBuilder<Users>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Users users = snapshot.data!;
            return ListView.builder(
              itemCount: users.users.length,
              itemBuilder: (context, index) {
                User user = users.users[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Set your desired background color
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
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Add ban logic here
                            },
                            child: Text('Ban'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Add unban logic here
                            },
                            child: Text('Unban'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),



    );
  }
}


