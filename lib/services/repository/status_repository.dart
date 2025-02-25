part of '../api_service.dart';

class StatusRepository {
  Future<Map<String, int>> getItemStatus() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(kBaseUrl + ApiEndPoint.kApiItemStatus),
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
      throw Exception(
        'Failed to load item statistics (Status Code: ${response.statusCode})',
      );
    }
  }
}
