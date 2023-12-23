import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/Equipment.dart';
import '../../services/EquipmentService.dart';

class AddEquipmentScreen extends StatefulWidget {
  final String userId;
  final EquipmentService equipmentService = EquipmentService();

  AddEquipmentScreen({required this.userId});

  @override
  _AddEquipmentScreenState createState() => _AddEquipmentScreenState();
}

class _AddEquipmentScreenState extends State<AddEquipmentScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController etatController;
  late TextEditingController categorieController;

  Uint8List? _pickedImageBytes;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    etatController = TextEditingController();
    categorieController = TextEditingController();
  }

  Widget buildEditableField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          controller: controller,
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
      // Affichez l'image sélectionnée depuis ImagePicker
      return Image.memory(
        _pickedImageBytes!,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else {
      // Vous pouvez afficher une icône ou un espace réservé pour l'image ici
      return Container(
        height: 150,
        width: 150,
        color: Colors.grey, // Placeholder color
      );
    }
  }

  void _saveChanges() async {
    try {
      // Get values from controllers
      String name = nameController.text;
      String description = descriptionController.text;
      String etat = etatController.text;
      String category = categorieController.text; // Assuming you have a 'category' field

      // Log the data before sending
      print('Name: $name');
      print('Description: $description');
      print('Etat: $etat');
      print('Category: $category');
      print('UserId: ${widget.userId}');

      // Call the addEquipment method from the EquipmentService
      await widget.equipmentService.addEquipment(
        userId: widget.userId,
        name: name,
        description: description,
        imageBytes: _pickedImageBytes, // Pass the selected image bytes
        etat: etat,
        category: category,
      );

      // Fetch the updated equipment list after adding new equipment
      await _fetchEquipmentList();

      // Optionally, you can navigate back to the previous screen or perform other actions
      Navigator.pop(context);
    } catch (e) {
      // Handle any errors that may occur during the modification process
      print('Error saving changes: $e');
      // Optionally, you can show an error message to the user
      // or perform other error-handling actions
    }
  }


  Future<void> _fetchEquipmentList() async {
    try {
      final List<Equipment> userEquipmentList =
      await widget.equipmentService.getEquipmentByUserId(widget.userId);
      widget.equipmentService.setEquipmentList(userEquipmentList);
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
        title: Text('Add Equipment for User ${widget.userId}'),
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
            buildEditableField('Categorie', categorieController),
            buildEditableField('Etat', etatController),
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
              child: Text('Save'),
            ),
          ],
        ),
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
