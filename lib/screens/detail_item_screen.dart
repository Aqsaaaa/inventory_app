import 'package:flutter/material.dart';
import 'package:inventory/models/item.dart';
import 'package:inventory/services/api_service.dart';

class DetailItemScreen extends StatefulWidget {
  final int id;

  const DetailItemScreen({super.key, required this.id});

  @override
  State<DetailItemScreen> createState() => _DetailItemScreenState();
}

class _DetailItemScreenState extends State<DetailItemScreen> {
  final ItemsRepository _itemsRepository = ItemsRepository();
  Item? _item;
  bool _isLoading = false;
  bool _isError = false;

  

  Future<void> _loadItem() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    try {
      var item = await _itemsRepository.getItemDetail(widget.id);
      if (mounted) {
        setState(() {
          _item = item;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isError = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to load item")),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Item')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isError || _item == null
              ? const Center(child: Text("Item not found"))
              : SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _item!.nama,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Kategori: ${_item!.kategori}",
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Jumlah: ${_item!.jumlah}",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}
