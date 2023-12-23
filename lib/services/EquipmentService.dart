import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


import '../models/Equipment.dart';

class EquipmentService {
  static const String apiUrl = 'http://localhost:9090/equipments/';
  static const String userEquipmentUrl = 'http://localhost:9090/equipments/user/'; // Adjust the URL according to your API

  List<Equipment> _equipmentList = [];

  final _equipmentStreamController = StreamController<List<Equipment>>.broadcast();

  Future<void> fetchEquipmentList() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _equipmentList = data.map((item) => Equipment.fromJson(item)).toList();
        _notifyListeners();
      } else {
        throw Exception('Failed to load equipment list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching equipment list: $e');
    }
  }

  Future<void> modifyEquipment({
    required String equipmentId,
    required String name,
    required String description,
    required Uint8List? imageBytes,
    required String etat,
    required String category,
  }) async {
    try {
      final uri = Uri.parse('$apiUrl$equipmentId');

      final request = http.MultipartRequest('PUT', uri)
        ..fields['name'] = name
        ..fields['description'] = description
        ..fields['etat'] = etat
        ..fields['category'] = category;

      if (imageBytes != null) {
        // Add image as a file to the request
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'image.jpg', // You can adjust the filename as needed
          contentType: MediaType('image', 'jpg'), // Adjust the content type based on your image type
        ));
      }

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        // Successfully modified equipment, you might want to update the local list
        await fetchEquipmentList();
      } else {
        throw Exception('Failed to modify equipment. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error modifying equipment: $e');
    }
  }


  Future<void> addEquipment({
    required String userId,
    required String name,
    required String description,
    required Uint8List? imageBytes,
    required String etat,
    required String category,
  }) async {
    try {
      final uri = Uri.parse(apiUrl);

      final request = http.MultipartRequest('POST', uri)
        ..fields['userId'] = userId
        ..fields['name'] = name
        ..fields['description'] = description
        ..fields['etat'] = etat
        ..fields['categorie'] = category;

      if (imageBytes != null) {
        // Add image as a file to the request
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'image.jpg', // You can adjust the filename as needed
          contentType: MediaType('image', 'jpg'), // Adjust the content type based on your image type
        ));
      }

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 201) {
        // Successfully added equipment, you might want to update the local list
        await fetchEquipmentList();
      } else {
        print('Failed to add equipment. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to add equipment. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding equipment: $e');
      throw Exception('Error adding equipment: $e');
    }
  }





  Future<List<Equipment>> getEquipmentByUserId(String userId) async {
    try {
      final response = await http.get(Uri.parse('$userEquipmentUrl$userId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Equipment.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load equipment list for user $userId. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching equipment list for user $userId: $e');
    }
  }


  Future<Image> loadImageFromUrl(String imageUrl) async {
    try {
      final fullUrl = 'http://localhost:9090/$imageUrl'; // Prepend the base URL
      final response = await http.get(Uri.parse(fullUrl));

      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;
        return Image.memory(
          bytes,
          height: 150,
          width: double.infinity,
          fit: BoxFit.contain, // Try different fit options
        );
      } else {
        throw Exception('Failed to load image from URL. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading image from URL: $e');
    }
  }




  List<Equipment> get equipmentList => _equipmentList;

  Stream<List<Equipment>> get equipmentStream => _equipmentStreamController.stream;

  void _notifyListeners() {
    _equipmentStreamController.add(_equipmentList);
  }

  void dispose() {
    _equipmentStreamController.close();
  }
  void setEquipmentList(List<Equipment> equipmentList) {
    _equipmentList = equipmentList;
    _notifyListeners();
  }
}
