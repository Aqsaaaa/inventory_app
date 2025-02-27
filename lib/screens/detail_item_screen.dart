import 'package:flutter/material.dart';
import 'package:inventory/gen/colors.gen.dart';
import 'package:inventory/models/history.dart';
import 'package:inventory/models/item.dart';
import 'package:inventory/services/api_service.dart';

class DetailItemScreen extends StatefulWidget {
  final int id;

  const DetailItemScreen({super.key, required this.id});

  @override
  State<DetailItemScreen> createState() => _DetailItemScreenState();
}

class _DetailItemScreenState extends State<DetailItemScreen> {
  final ItemsRepository itemsRepository = ItemsRepository();
  final HistoryRepository _historyRepository = HistoryRepository();
  Item? _item;
  bool _isLoading = false;
  bool _isError = false;

  final TextEditingController _namaPeminjamController = TextEditingController();
  final TextEditingController _jumlahYangDipinjamController =
      TextEditingController();

  Future<void> _postItem(String newStatus) async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    try {
      await _historyRepository.addHistory(
        History(
          status: newStatus,
          idBarang: widget.id,
          namaBarang: _item!.nama,
          name: _item!.nama,
          namaPeminjam: _namaPeminjamController.text,
          jumlahYangDipinjam: int.parse(_jumlahYangDipinjamController.text),
          alasan: '',
        ),
      );

      // await _updateItemQuantity(int.parse(_jumlahYangDipinjamController.text));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Status berhasil diperbarui ke '$newStatus'!")),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isError = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal memperbarui status")),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Future<void> _updateItemQuantity(int quantity) async {
  //   try {
  //     if (item != null) {
  //       int jumlahSebelumnya = item!.jumlah ?? 0;
  //       int jumlahBaru = jumlahSebelumnya - quantity;

  //       if (jumlahBaru < 0) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("Jumlah tidak boleh kurang dari 0")),
  //         );
  //         return;
  //       }

  //       item!.jumlah = jumlahBaru;
  //       print("Jumlah sebelumnya: $jumlahSebelumnya");
  //       print("Jumlah dipinjam: $quantity");
  //       print("Jumlah baru: $jumlahBaru");

  //       await itemsRepository.putItem(item!); // Kirim ke API
  //       await _loadItem(); // Reload data untuk memastikan perubahan berhasil

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Jumlah item berhasil diperbarui!")),
  //       );
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       setState(() {
  //         _isError = true;
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Gagal memperbarui jumlah item")),
  //       );
  //     }
  //   }
  // }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'dipakai':
        return ColorName.bgGreen;
      case 'dikembalikan':
        return ColorName.bgYellow;
      case 'rusak':
        return ColorName.bgRed;
      default:
        return ColorName.bgBlue;
    }
  }

  Color _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'dipakai':
        return ColorName.textGreen;
      case 'dikembalikan':
        return ColorName.textYellow;
      case 'rusak':
        return ColorName.textRed;
      default:
        return ColorName.textBlue;
    }
  }

  Future<void> _loadItem() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    try {
      var item = await itemsRepository.getItemDetail(widget.id);
      if (mounted) {
        setState(() {
          _item = item;
          _isError = _item == null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isError = true;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to load item")));
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
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _isError || _item == null
              ? const Center(child: Text("Item not found"))
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          _item!.nama,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child:
                            _item!.image != null
                                ? Image.network(
                                  "http://10.0.2.2:3000/api/uploads/${_item!.image}",
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                                : Container(
                                  height: 200,
                                  width: double.infinity,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.image_not_supported),
                                ),
                      ),
                      SizedBox(height: 8),
                      Status(
                        description: _item!.status,
                        warna: _getStatusText(_item!.status),
                        bg: _getStatusColor(_item!.status),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Kategori: ${_item!.kategori}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Jumlah: ${_item!.jumlah}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _namaPeminjamController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Peminjam',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _jumlahYangDipinjamController,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah Yang Dipinjam',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SubmitButton(
                              description: _item!.status,
                              warna: _getStatusText(_item!.status),
                              bg: _getStatusColor(_item!.status),
                              onPressed: () => _postItem('dipakai'),
                            ),
                            SizedBox(width: 8),
                            SubmitButton(
                              description: _item!.status,
                              warna: _getStatusText(_item!.status),
                              bg: _getStatusColor(_item!.status),
                              onPressed: () => _postItem('dikembalikan'),
                            ),
                            SizedBox(width: 8),
                            SubmitButton(
                              description: _item!.status,
                              warna: _getStatusText(_item!.status),
                              bg: _getStatusColor(_item!.status),
                              onPressed: () => _postItem('rusak'),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}

class Status extends StatelessWidget {
  final String description;
  final Color warna;
  final Color bg;

  const Status({
    super.key,
    required this.description,
    required this.warna,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Text(
        description,
        style: TextStyle(color: warna, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  final String description;
  final Color warna;
  final Color bg;
  final VoidCallback onPressed;

  const SubmitButton({
    super.key,
    required this.description,
    required this.warna,
    required this.bg,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Text(
          description,
          style: TextStyle(color: warna, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
