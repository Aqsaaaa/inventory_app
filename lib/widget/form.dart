import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory/models/item.dart';
import 'dart:io';

import 'package:inventory/services/api_service.dart';

class UploadForm extends StatefulWidget {
  final String formMode;

  const UploadForm({super.key, required this.formMode});

  @override
  _ImageUploadFormState createState() => _ImageUploadFormState();
}

class _ImageUploadFormState extends State<UploadForm> {
  File? _selectedImage;
  final _namaController = TextEditingController();
  final _kategoriController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final ItemsRepository _itemsRepository = ItemsRepository();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) return;
    setState(() {
      _selectedImage = File(pickedFile.path);
    });
  }

  void _addItem() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final item = Item(
        nama: _namaController.text,
        kategori: _kategoriController.text,
        jumlah: int.parse(_jumlahController.text),
        deskripsi: _deskripsiController.text,
        status: 'tersedia',
      );
      await _itemsRepository.addItem(item);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Item added successfully')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add item')));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.formMode == 'add' ? 'User Input Form' : 'Update Form',
        ),
        backgroundColor: Color(0xFF90CAF9),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Upload Section
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 120,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.photo_camera),
                                title: Text('Take a photo'),
                                onTap: () {
                                  _pickCamera();
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text('Choose from gallery'),
                                onTap: () {
                                  _pickImage();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
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
                                  'Tap to Upload Image',
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

                CustomTextFormField(
                  controller: _namaController,
                  labelText: "Nama",
                  prefixIcon: Icons.person,
                  validator:
                      (value) => value!.isEmpty ? 'Nama is required' : null,
                ),
                CustomTextFormField(
                  controller: _kategoriController,
                  labelText: "Kategori",
                  prefixIcon: Icons.person,
                  validator:
                      (value) => value!.isEmpty ? 'Kategori is required' : null,
                ),
                CustomTextFormField(
                  controller: _jumlahController,
                  labelText: "Jumlah",
                  prefixIcon: Icons.person,
                  validator:
                      (value) => value!.isEmpty ? 'Jumlah is required' : null,
                ),
                CustomTextFormField(
                  controller: _deskripsiController,
                  labelText: "Deskripsi",
                  prefixIcon: Icons.person,
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Deskripsi is required' : null,
                ),
                // Submit Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _addItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 109, 163, 243),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading ? CircularProgressIndicator() : Text(
                    widget.formMode == 'add' ? 'Submit' : 'Update',
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
    _jumlahController.dispose();
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
