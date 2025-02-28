import 'package:flutter/material.dart';
import 'package:inventory/gen/colors.gen.dart';
import 'package:inventory/models/history.dart';
import 'package:inventory/models/item.dart';
import 'package:inventory/services/api_service.dart';
import 'package:inventory/widget/button_widget.dart';
import 'package:inventory/widget/modal_widget.dart';
import 'package:inventory/widget/status_widget.dart';

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
  final TextEditingController _alasanController = TextEditingController();

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
          namaPeminjam: _namaPeminjamController.text,
          jumlahYangDipinjam: int.parse(_jumlahYangDipinjamController.text),
          alasan: _alasanController.text,
        ),
      );

      await _updateItem(int.parse(_jumlahYangDipinjamController.text));
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

  Future<void> _updateItem(int quantity) async {
    try {
      if (_item != null) {
        int jumlahSebelumnya = _item!.jumlah ?? 0;
        int jumlahBaru;

        if (_item!.status.toLowerCase() == 'dikembalikan') {
          jumlahBaru = jumlahSebelumnya + quantity;
        } else {
          jumlahBaru = jumlahSebelumnya - quantity;
        }

        if (jumlahBaru < 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Jumlah tidak boleh kurang dari 0")),
          );
          return;
        }

        await itemsRepository.putItem(
          Item(
            id: widget.id,
            jumlah: jumlahBaru,
            nama: _item!.nama,
            kategori: _item!.kategori,
            status: _item!.status,
            image: _item!.image,
            deskripsi: _item!.deskripsi,
          ),
        );

        await _loadItem();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Jumlah item berhasil diperbarui!")),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isError = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal memperbarui jumlah item")),
        );
      }
    }
  }

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
                      const SizedBox(height: 16),
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
                      SizedBox(height: 16),
                      Status(
                        description: _item!.status,
                        warna: ColorName.background,
                        bg: _getStatusColor(_item!.status),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Kategori: ${_item!.kategori}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Jumlah: ${_item!.jumlah}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _namaPeminjamController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Peminjam',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _jumlahYangDipinjamController,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah Yang Dipinjam',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Jumlah tidak boleh kosong';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SubmitButton(
                              description: "Pakai",
                              warna: ColorName.background,
                              bg: ColorName.bgGreen,
                              onPressed:
                                  () => showCustomModalBottomSheett(
                                    context: context,
                                    alasanController: _alasanController,
                                    bgSubmit: ColorName.bgGreen,
                                    onSubmit: () => _postItem('Dipakai'),
                                  ),
                            ),
                            SizedBox(width: 8),
                            SubmitButton(
                              description: "Rusak",
                              warna: ColorName.background,
                              bg: ColorName.bgRed,
                              onPressed:
                                  () => showCustomModalBottomSheett(
                                    context: context,
                                    alasanController: _alasanController,
                                    bgSubmit: ColorName.bgGreen,
                                    onSubmit: () => _postItem('Rusak'),
                                  ),
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
