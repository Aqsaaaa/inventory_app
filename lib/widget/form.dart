import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory/models/item.dart';
import 'dart:io';
import 'dart:developer' as developer; // Untuk logging

import 'package:inventory/services/api_service.dart';

class UploadForm extends StatefulWidget {
  final String formMode;
  final Item? existingItem;

  const UploadForm({super.key, required this.formMode, this.existingItem});

  @override
  _UploadFormState createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  File? _selectedImage;
  final _namaController = TextEditingController();
  final _kategoriController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final ItemsRepository _itemsRepository = ItemsRepository();
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      // Tambahkan logging untuk debugging
      developer.log(
        'Attempting to pick image from $source',
        name: 'UploadForm._pickImage',
      );

      final pickedFile = await _picker.pickImage(
        source: source,
        // Tambahkan opsi kompresi dan kualitas gambar
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      // Log detail file yang dipilih
      if (pickedFile != null) {
        developer.log(
          'Image picked: ${pickedFile.path}',
          name: 'UploadForm._pickImage',
        );

        // Validasi file
        final file = File(pickedFile.path);
        if (!file.existsSync()) {
          _showErrorDialog('File gambar tidak ditemukan');
          return;
        }

        // Periksa ukuran file
        final fileSize = file.lengthSync();
        developer.log(
          'Image file size: $fileSize bytes',
          name: 'UploadForm._pickImage',
        );

        if (fileSize == 0) {
          _showErrorDialog('Ukuran file gambar 0 byte');
          return;
        }

        if (mounted) {
          setState(() {
            _selectedImage = file;
          });
        }
      } else {
        developer.log('No image selected', name: 'UploadForm._pickImage');
        _showErrorDialog('Tidak ada gambar yang dipilih');
      }
    } catch (e) {
      // Log error terperinci
      developer.log(
        'Error picking image',
        name: 'UploadForm._pickImage',
        error: e,
      );

      if (mounted) {
        _showErrorDialog('Gagal memilih gambar: $e');
      }
    }
  }

  // Tambahkan metode untuk menampilkan dialog error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text('Tutup'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
    );
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Ambil Foto'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _addOrUpdateItem() async {
    if (!_formKey.currentState!.validate()) return;

    // Tambahkan pengecekan mounted sebelum setState
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final item = Item(
        nama: _namaController.text,
        kategori: _kategoriController.text,
        jumlah: int.parse(_jumlahController.text),
        deskripsi: _deskripsiController.text,
        status: 'tersedia',
      );

      if (widget.formMode == 'add') {
        await _itemsRepository.addItem(item);
      } else {
        // Logika update item
        // await _itemsRepository.updateItem(item);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.formMode == 'add'
                  ? 'Item berhasil ditambahkan'
                  : 'Item berhasil diperbarui',
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      // Tambahkan pengecekan mounted sebelum menampilkan SnackBar
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan item: $e')));
      }
    } finally {
      // Tambahkan pengecekan mounted sebelum setState
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.formMode == 'add' ? 'Tambah Item' : 'Edit Item'),
        backgroundColor: Color(0xFF90CAF9),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Bagian Upload Gambar dengan perbaikan
                GestureDetector(
                  onTap: _showImagePickerBottomSheet,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFF0D47A1)),
                    ),
                    child:
                        _selectedImage != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                            : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload,
                                  size: 50,
                                  color: Color(0xFF90CAF9),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Tambah Gambar',
                                  style: TextStyle(
                                    color: Color(0xFF90CAF9),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
                SizedBox(height: 20),

                // Form input lainnya
                CustomTextFormField(
                  controller: _namaController,
                  labelText: "Nama",
                  prefixIcon: Icons.text_fields,
                  validator:
                      (value) => value!.isEmpty ? 'Nama harus diisi' : null,
                ),
                CustomTextFormField(
                  controller: _kategoriController,
                  labelText: "Kategori",
                  prefixIcon: Icons.category,
                  validator:
                      (value) => value!.isEmpty ? 'Kategori harus diisi' : null,
                ),
                CustomTextFormField(
                  controller: _jumlahController,
                  labelText: "Jumlah",
                  prefixIcon: Icons.numbers,
                  keyboardType: TextInputType.number,
                  validator:
                      (value) => value!.isEmpty ? 'Jumlah harus diisi' : null,
                ),
                CustomTextFormField(
                  controller: _deskripsiController,
                  labelText: "Deskripsi",
                  prefixIcon: Icons.description,
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Deskripsi harus diisi' : null,
                ),

                // Tombol Submit
                ElevatedButton(
                  onPressed: _isLoading ? null : _addOrUpdateItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 109, 163, 243),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _isLoading
                          ? CircularProgressIndicator()
                          : Text(
                            widget.formMode == 'add' ? 'Simpan' : 'Perbarui',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kategoriController.dispose();
    _jumlahController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: Icon(prefixIcon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF0D47A1)),
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          validator: validator,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
