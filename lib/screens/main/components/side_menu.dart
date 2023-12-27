import 'package:admin/screens/dashboard/user_detail_screen.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:admin/screens/dashboard/equipment_screen.dart';
import 'package:admin/screens/dashboard/maintenance_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../services/AuthService.dart';
import '../../dashboard/login_screen.dart';
import '../main_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              // Handle Dashboard press
            },
          ),
          DrawerListTile(
            title: "Maintenance",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MaintenanceScreen()),
              );
            },
          ),
          DrawerListTile(
            title: "Equipment",
            svgSrc: "assets/icons/menu_equipment.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EquipmentScreen()),
              );
            },
          ),
          DrawerListTile(
            title: "Notification",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {
              // Handle Notification press
            },
          ),
          DrawerListTile(
            title: "Profile",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserDetailScreen()),
              );
            },
          ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              // Handle Settings press
            },
          ),
          // Add the Logout button
          DrawerListTile(
            title: "Logout",
            svgSrc: "assets/icons/menu_logout.svg", // You can use a logout icon
            press: () {
              // Implement the logout functionality here
              // For example, clear the user session and navigate to the login screen
              // You can customize this part based on your authentication logic
              // Here's a simple example:
              _handleLogout(context);
            },
          ),
        ],
      ),
    );
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
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
