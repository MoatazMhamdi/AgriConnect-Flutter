import 'package:flutter/material.dart';

class MaintenanceScreen extends StatefulWidget {
  @override
  _MaintenanceScreenState createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  List<MaintenanceItem> maintenanceList = [
    MaintenanceItem('Maintenance 1', 'Description 1'),
    MaintenanceItem('Maintenance 2', 'Description 2'),
    MaintenanceItem('Maintenance 3', 'Description 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maintenance Screen'),
      ),
      body: ListView.builder(
        itemCount: maintenanceList.length,
        itemBuilder: (context, index) {
          MaintenanceItem maintenanceItem = maintenanceList[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(maintenanceItem.title),
              subtitle: Text(maintenanceItem.description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Show edit bottom sheet
                      _showEditMaintenanceItemSheet(index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Handle delete action
                      _deleteMaintenanceItem(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show add bottom sheet
          _showAddMaintenanceItemSheet();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addMaintenanceItem(String title, String description) {
    setState(() {
      maintenanceList.add(MaintenanceItem(title, description));
    });
  }

  void _editMaintenanceItem(int index, String newTitle, String newDescription) {
    setState(() {
      maintenanceList[index] = MaintenanceItem(newTitle, newDescription);
    });
  }

  void _deleteMaintenanceItem(int index) {
    setState(() {
      maintenanceList.removeAt(index);
    });
  }

  void _showAddMaintenanceItemSheet() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Maintenance Item',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle add action
                  _addMaintenanceItem(titleController.text, descriptionController.text);
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: Text('Add Maintenance Item'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditMaintenanceItemSheet(int index) {
    MaintenanceItem maintenanceItem = maintenanceList[index];
    TextEditingController titleController = TextEditingController(text: maintenanceItem.title);
    TextEditingController descriptionController = TextEditingController(text: maintenanceItem.description);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Maintenance Item',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle edit action
                  _editMaintenanceItem(index, titleController.text, descriptionController.text);
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MaintenanceItem {
  final String title;
  final String description;

  MaintenanceItem(this.title, this.description);
}
