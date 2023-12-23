import 'package:flutter/material.dart';
import '../../models/Equipment.dart';
import '../../models/User.dart';
import '../../services/EquipmentService.dart';
import 'package:http/http.dart' as http;

import 'equipment_detail_screen.dart';
import 'add_equipment_screen.dart';

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
      // ... (your existing error handling code)
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equipment for ${widget.user.name}'),
      ),
      body: Flexible(
        child: SingleChildScrollView(
          child: Padding(
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddEquipmentScreen,
        tooltip: 'Add Equipment',
        child: Icon(Icons.add),
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(equipment.description),
                        if (equipment.image != null)
                          FutureBuilder<Image>(
                            future: _equipmentService.loadImageFromUrl(equipment.image!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return snapshot.data ?? Container(); // Display the image or an empty container
                              } else if (snapshot.hasError) {
                                return Text('Error loading image: ${snapshot.error}');
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteEquipment(equipment);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
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

  void _navigateToAddEquipmentScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEquipmentScreen(userId: widget.user.id),
      ),
    );
  }
}
