part of '../api_service.dart';

class HistoryRepository {
  Future<List<History>> getHistory() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$kBaseUrl/history'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => History.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load history');
    }
  }

  Future<Map<String, dynamic>> addHistory(History history) async {
    try {
      final token = await getToken();
      final response = await http.post(
        Uri.parse(kBaseUrl + ApiEndPoint.kApiHistory),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(history.toJson()),
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

}


  
