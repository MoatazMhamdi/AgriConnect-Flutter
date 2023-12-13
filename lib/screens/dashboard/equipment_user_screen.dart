import 'package:flutter/material.dart';
import '../../models/Equipment.dart';
import '../../models/User.dart';
import '../../services/EquipmentService.dart';
import 'package:http/http.dart' as http;

import 'equipment_detail_screen.dart';

class EquipmentUserScreen extends StatefulWidget {
  final User user;

  EquipmentUserScreen({required this.user});

  @override
  _EquipmentUserScreenState createState() => _EquipmentUserScreenState();
}

class _EquipmentUserScreenState extends State<EquipmentUserScreen> {
  final EquipmentService _equipmentService = EquipmentService();

  @override
  void initState() {
    super.initState();
    _fetchEquipmentList();
  }

  Future<void> _fetchEquipmentList() async {
    try {
      final List<Equipment> userEquipmentList =
      await _equipmentService.getEquipmentByUserId(widget.user.id);
      _equipmentService.setEquipmentList(userEquipmentList);
    } catch (e) {
      print('Error fetching equipment list: $e');
      if (e is http.Response) {
        if (e.statusCode == 404) {
          print('No equipment found for this user.');
        } else {
          print('Unexpected status code: ${e.statusCode}');
          print('Response body: ${e.body}');
        }
      } else {
        // Log the full exception for debugging purposes
        print('An unexpected error occurred while fetching equipment list: $e');
        // Handle other errors, e.g., show a generic error message to the user
        print('An unexpected error occurred while fetching equipment list.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equipment for ${widget.user.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('ID: ${widget.user.id}'),
            Text('Name: ${widget.user.name}'),
            Text('Email: ${widget.user.email}'),
            SizedBox(height: 16),
            Text(
              'Equipment List',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildEquipmentList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentList() {
    return StreamBuilder<List<Equipment>>(
      stream: _equipmentService.equipmentStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Equipment> equipmentList = snapshot.data!;
          if (equipmentList.isEmpty) {
            return Text('No equipment available for this user.');
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: equipmentList.length,
              itemBuilder: (context, index) {
                final Equipment equipment = equipmentList[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(equipment.name),
                    subtitle: Text(equipment.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Handle delete operation
                            _deleteEquipment(equipment);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigate to EquipmentDetailScreen when tapped
                      _navigateToEquipmentDetailScreen(equipment);
                    },
                  ),
                );
              },
            );
          }
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  void _navigateToEquipmentDetailScreen(Equipment equipment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EquipmentDetailScreen(equipment: equipment),
      ),
    );
  }


  void _deleteEquipment(Equipment equipment) {
    // Implement your delete logic here
  }

}
