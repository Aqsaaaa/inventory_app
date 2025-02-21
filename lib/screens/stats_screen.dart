import 'package:flutter/material.dart';
import 'package:inventory/services/api_service.dart';

ApiService apiService = ApiService();

class ItemStatsScreen extends StatefulWidget {
  const ItemStatsScreen({super.key});

  @override
  _ItemStatsScreenState createState() => _ItemStatsScreenState();
}

class _ItemStatsScreenState extends State<ItemStatsScreen> {
  late Future<List<Map<String, int>>> _futureStats;
  final ApiService _apiService = ApiService();
  // ignore: unused_field
  bool _isLoading = false;

  void _loadStats() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _futureStats =
          _apiService.getItemStats() as Future<List<Map<String, int>>>;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to get stats of items')));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Item Statistics')),
      body: FutureBuilder<List<Map<String, int>>>(
        future: _futureStats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          final stats = snapshot.data!.first;
          return ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              _buildStatCard('Dipakai', stats['dipakai']!),
              _buildStatCard('Dikembalikan', stats['dikembalikan']!),
              _buildStatCard('Rusak', stats['rusak']!),
              _buildStatCard('Tersedia', stats['tersedia']!),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, int value) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: Text(value.toString(), style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
