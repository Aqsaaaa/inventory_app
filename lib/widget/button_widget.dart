import 'package:flutter/material.dart';

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
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Text(
          description,
          style: TextStyle(
            color: warna,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
