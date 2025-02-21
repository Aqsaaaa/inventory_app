import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final ApiService _apiService = ApiService();

  bool _isLoading = false;

  void _addItem() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _apiService.addItem(
        _namaController.text,
        _kategoriController.text,
        int.parse(_jumlahController.text),
        _deskripsiController.text,
        'tersedia',
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item added successfully')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add item')));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Item")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _namaController, decoration: InputDecoration(labelText: 'Nama')),
            TextField(controller: _kategoriController, decoration: InputDecoration(labelText: 'Kategori')),
            TextField(controller: _jumlahController, decoration: InputDecoration(labelText: 'Jumlah')),
            TextField(controller: _deskripsiController, decoration: InputDecoration(labelText: 'Deskripsi')),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _addItem,
                    child: Text('Add Item'),
                  ),
          ],
        ),
      ),
    );
  }
}
