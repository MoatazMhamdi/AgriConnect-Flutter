import 'package:admin/screens/dashboard/UserScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/AuthService.dart';
import 'login_screen.dart';

class User {
  final String? name;

  User({this.name});
}

class UserDetailScreen extends StatelessWidget {
  UserDetailScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Detail'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: _TopPortion(),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  FutureBuilder<User?>(
                    future: getUserDetails(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return Text('User details not found');
                      } else {
                        final user = snapshot.data!;

                        return Column(
                          children: [
                            Text(
                              user.name ?? 'User Name',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FloatingActionButton.extended(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserScreen(),
                                      ),
                                    );
                                  },
                                  heroTag: 'Users List',
                                  elevation: 0,
                                  label: const Text("Users List"),
                                  icon: const Icon(Icons.format_list_numbered_outlined),
                                ),
                                const SizedBox(width: 16.0),
                                FloatingActionButton.extended(
                                  onPressed: () {
                                     _handleLogout(context);
                                  },
                                  heroTag: 'Logout',
                                  elevation: 0,
                                  backgroundColor: Colors.red,
                                  label: const Text("Logout"),
                                  icon: const Icon(Icons.logout),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const _ProfileInfoRow(),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<User?> getUserDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('name') ?? 'Richie Lorie';
      return User(name: name);
    } catch (e) {
      print('Error retrieving user details from local storage: $e');
      return null;
    }
  }
}
Future<void> _handleLogout(BuildContext context) async {
  final authService = AuthService();
  try {
    // Call the logout method
    await authService.logout();

    // Navigate to the login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
          (route) => false,
    );
  } catch (e) {
    print('Error during logout: $e');
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
    /*  height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map((item) => Expanded(
          child: Row(
            children: [
              if (_items.indexOf(item) != 0)
                const VerticalDivider(),
              Expanded(child: _singleItem(context, item)),
            ],
          ),
        ))
            .toList(),
      ),*/
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          item.value.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      Text(
        item.title,
        style: Theme.of(context).textTheme.caption,
      )
    ],
  );
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xff0043ba), Color(0xff006df1)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/software-engineer.png',
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}
