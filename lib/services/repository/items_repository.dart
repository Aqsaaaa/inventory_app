part of '../api_service.dart';

class ItemsRepository {
  Future<List<Item>> getItems() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$kBaseUrl/items'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => Item.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<Item> getItemDetail(int id) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$kBaseUrl/items/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Item.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load item detail');
    }
  }

  Future<Map<String, dynamic>> addItem(Item item) async {
    try {
      final token = await getToken();
      final response = await http.post(
        Uri.parse(kBaseUrl + ApiEndPoint.kApiItem),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Item added successfully'};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to add item',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error occurred'};
    }
  }

  Future<Map<String, dynamic>> putItem(Item item) async {
    try {
      final token = await getToken();
      final response = await http.put(
        Uri.parse('$kBaseUrl/items/${item.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Item updated successfully'};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to update item',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error occurred'};
    }
  }
}
