import 'package:flutter/material.dart';
import 'package:inventory/services/api_service.dart';

class ItemStatsScreen extends StatefulWidget {
  const ItemStatsScreen({super.key});

  @override
  _ItemStatsScreenState createState() => _ItemStatsScreenState();
}

class _ItemStatsScreenState extends State<ItemStatsScreen> {
  late Future<Map<String, int>> _futureStats;
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _loadStats() {
    setState(() {
      _isLoading = true;
    });

    _futureStats = _apiService.getItemStats();

    _futureStats
        .then((_) {
          setState(() {
            _isLoading = false;
          });
        })
        .catchError((e) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to get stats of items: $e')),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'STATISTIC',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : FutureBuilder<Map<String, int>>(
                future: _futureStats,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  }

                  final stats = snapshot.data!;
                  return ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      _buildStatCard('Dipakai', stats['dipakai'] ?? 0),
                      _buildStatCard(
                        'Dikembalikan',
                        stats['dikembalikan'] ?? 0,
                      ),
                      _buildStatCard('Rusak', stats['rusak'] ?? 0),
                      _buildStatCard('Tersedia', stats['tersedia'] ?? 0),
                    ],
                  );
                },
              ),
    );
  }

  // Widget _buildStatCard(String title, int value) {
  //   return Column(children: [Text(title), Text(value.toString())]);
  // }

  Widget _buildStatCard(String title, int value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(value.toString(), style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
