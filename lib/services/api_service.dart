import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/item.dart';
import '../models/history.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  final FlutterSecureStorage _storage = FlutterSecureStorage();


  Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  // Login
  Future<Map<String, dynamic>> login(int nrp, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'nrp': nrp, 'password': password}),
      );

      final data = json.decode(response.body);
      print(data);

      if (response.statusCode == 200) {
        await _storage.write(key: 'token', value: data['token']);
        return {'success': true, 'message': 'Login successful'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error occurred'};
    }
  }

  Future<List<Item>> getItems() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/items'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => Item.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  // Add Item
  Future<void> addItem(String nama, String kategori, int jumlah,
      String deskripsi, String status) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/items'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'nama': nama,
        'kategori': kategori,
        'jumlah': jumlah,
        'deskripsi': deskripsi,
        'status': status,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add item');
    }
  }

  // Get Item History
  Future<List<History>> getHistory(int itemId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/history/$itemId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => History.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load history');
    }
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }

  Future<Map<String, int>> getItemStats() async {
    final token = await _getToken();
    print('Token: $token');
    final response = await http.get(
      Uri.parse('$baseUrl/status'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      if (body is List && body.isNotEmpty) {
        final Map<String, dynamic> jsonData = body.first;

        return {
          'dipakai': (jsonData['dipakai'] ?? 0) as int,
          'dikembalikan': (jsonData['dikembalikan'] ?? 0) as int,
          'rusak': (jsonData['rusak'] ?? 0) as int,
          'tersedia': (jsonData['tersedia'] ?? 0) as int,
        };
      } else {
        throw Exception('Invalid API response: Expected a non-empty list');
      }
    } else {
      throw Exception('Failed to load item statistics (Status Code: ${response.statusCode})');
    }
  }
}
