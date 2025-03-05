part of '../api_service.dart';

class AuthRepository {
  Future<Map<String, dynamic>> login(int nrp, String password) async {
    try {
      final response = await http.post(
        Uri.parse(kBaseUrl + ApiEndPoint.kApiLogin),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'nrp': nrp, 'password': password}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        await Storage.write(key: 'token', value: data['token']);
        return {'success': true, 'message': 'Login successful'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error occurred'};
    }
  }

}
