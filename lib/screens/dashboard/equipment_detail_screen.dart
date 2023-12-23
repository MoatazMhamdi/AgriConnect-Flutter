import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/Equipment.dart';
import '../../services/EquipmentService.dart';
import 'mainteance_detail_screen.dart';
import 'maintenance_screen.dart';

class EquipmentDetailScreen extends StatefulWidget {
  final Equipment equipment;
  final EquipmentService equipmentService = EquipmentService();


  EquipmentDetailScreen({required this.equipment});

  @override
  _EquipmentDetailScreenState createState() => _EquipmentDetailScreenState();
}

class _EquipmentDetailScreenState extends State<EquipmentDetailScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController etatController;
  late TextEditingController categorieController;

  Uint8List? _pickedImageBytes;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.equipment.name);
    descriptionController = TextEditingController(text: widget.equipment.description);
    etatController = TextEditingController(text: widget.equipment.etat);
    categorieController = TextEditingController(text: widget.equipment.category);
  }

  Widget buildEditableField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 4),
        TextField(
          controller: controller,
          enabled: controller == nameController ||
              controller == descriptionController ||
              controller == etatController ||
              controller == categorieController,
          maxLines: label == 'Description' ? null : 1,
          keyboardType: label == 'Description' ? TextInputType.multiline : TextInputType.text,
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      print('Picked image path: ${pickedImage.path}');

      // Read image as Uint8List
      final pickedImageBytes = await pickedImage.readAsBytes();

      setState(() {
        _pickedImageBytes = pickedImageBytes;
      });
    }
  }

  Future<Widget> _loadImage() async {
    if (_pickedImageBytes != null) {
      // Display the selected image from ImagePicker
      return Image.memory(
        _pickedImageBytes!,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else {
      // Display the image from the backend if available
      return widget.equipmentService.loadImageFromUrl(widget.equipment.image!);
    }
  }

  void _saveChanges() async {
    try {
      // Get values from controllers
      String name = nameController.text;
      String description = descriptionController.text;
      String etat = etatController.text;
      String category = categorieController.text;

      // Call the modifyEquipment method from the EquipmentService
      await widget.equipmentService.modifyEquipment(
        equipmentId: widget.equipment.id,
        name: name,
        description: description,
        imageBytes: _pickedImageBytes,
        etat: etat,
        category: category,
      );

      // Optionally, you can navigate back to the previous screen or perform other actions
      Navigator.pop(context);
    } catch (e) {
      // Handle any errors that may occur during the modification process
      print('Error saving changes: $e');
      // Optionally, you can show an error message to the user
      // or perform other error-handling actions
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equipment Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Equipment Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              buildEditableField('Name', nameController),
              buildEditableField('Description', descriptionController),
              buildEditableField('Category', categorieController),
              buildEditableField('Condition', etatController),
              SizedBox(height: 16),
              FutureBuilder<Widget>(
                future: _loadImage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      children: [
                        snapshot.data ?? Container(),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            _pickImage();
                          },
                          child: Text('Upload Image'),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error loading image');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _saveChanges();
                },
                child: Text('Save Changes'),
              ),
              ElevatedButton(
                onPressed: () {

                },
                child: Text('Maintenances'),
              ),

            ],
          ),
        ),
      ),
    );
  }
  void _navigateToMaintenanceDetailScreen(Equipment equipment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MaintenanceDetailScreen(equipment: equipment),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
