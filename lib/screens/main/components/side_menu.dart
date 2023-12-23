import 'package:admin/screens/dashboard/user_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


import '../../dashboard/dashboard_screen.dart';
import '../../dashboard/equipment_screen.dart';
import '../../dashboard/maintenance_screen.dart';

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

            },
          ),
          DrawerListTile(
            title: "Maintenance",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              // Naviguer vers la vue Task
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MaintenanceScreen()),
              );
            },
          ),
          DrawerListTile(
            title: "Equipment", // Ajouter l'élément Equipment
            svgSrc: "assets/icons/menu_equipment.svg",
            press: () {
              // Naviguer vers la vue Equipment
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EquipmentScreen()),
              );
            },
          ),
          DrawerListTile(
            title: "Notification",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {},
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
            press: () {},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
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
