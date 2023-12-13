import 'package:flutter/material.dart';
import '../../models/Equipment.dart';
import '../../services/EquipmentService.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current values
    nameController = TextEditingController(text: widget.equipment.name);
    descriptionController =
        TextEditingController(text: widget.equipment.description);
  }

  Future<Widget> _loadImage() async {
    if (_pickedImage != null) {
      // Display the selected image from ImagePicker
      return Image.file(
        _pickedImage!,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (widget.equipment.image != null) {
      // Display the image from the backend if available
      return widget.equipmentService.loadImageFromUrl(widget.equipment.image!);
    } else {
      return Container(); // Return an empty container if no image is selected
    }
  }



  Widget buildEditableField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          controller: controller,
          enabled: controller == nameController || controller == descriptionController,
        ),
      ],
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        print('Picked image path: ${pickedImage.path}');
        // Convert temporary URL to File
        _pickedImage = File.fromUri(Uri.parse(pickedImage.path));
      }
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equipment Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Equipment Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            buildEditableField('Name', nameController),
            buildEditableField('Description', descriptionController),
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
                // Save changes when the "Save" button is pressed

              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the controllers to avoid memory leaks
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
