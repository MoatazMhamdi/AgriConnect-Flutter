import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

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
