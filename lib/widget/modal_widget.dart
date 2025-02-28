import 'package:flutter/material.dart';
import 'package:inventory/widget/button_widget.dart';

void showCustomModalBottomSheett({
  required BuildContext context,
  required TextEditingController alasanController,
  required Color bgSubmit,
  required void Function() onSubmit,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: alasanController,
            decoration: const InputDecoration(
              labelText: 'Alasan',
            ),
          ),
          const SizedBox(height: 16),
          SubmitButton(
            description: "Submit",
            warna: Colors.white,
            bg: bgSubmit,
            onPressed: onSubmit,
          ),
        ],
      ),
    ),
  );
}
