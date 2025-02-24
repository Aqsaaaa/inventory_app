import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

    @override
    _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
    Future<List<History>>? _notificationsFuture;

    @override
    void initState() {
        super.initState();
        _notificationsFuture = getNotifications();
    }

    Future<List<History>> getNotifications() async {
        final token = await _getToken();
        final response = await http.get(
            Uri.parse('$baseUrl/notifications'),
            headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
            List<dynamic> jsonData = json.decode(response.body);
            return jsonData.map((data) => History.fromJson(data)).toList();
        } else {
            throw Exception('Failed to load notifications');
        }
    }

    Future<String> _getToken() async {
        // Implement your token retrieval logic here
        return 'your_token';
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Notifications'),
            ),
            body: FutureBuilder<List<History>>(
                future: _notificationsFuture,
                builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                        return Center(child: Text('Failed to load notifications'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No new notifications'));
                    } else {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                                final notification = snapshot.data![index];
                                return ListTile(
                                    title: Text(notification.title),
                                    subtitle: Text(notification.body),
                                );
                            },
                        );
                    }
                },
            ),
        );
    }
}

class History {
    final String title;
    final String body;

    History({required this.title, required this.body});

    factory History.fromJson(Map<String, dynamic> json) {
        return History(
            title: json['title'],
            body: json['body'],
        );
    }
}