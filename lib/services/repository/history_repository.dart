part of '../api_service.dart';

class HistoryRepository {
  Future<List<History>> getHistory(int itemId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$kBaseUrl/history/$itemId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => History.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load history');
    }
  }
}
