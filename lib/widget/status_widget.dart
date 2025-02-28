import 'package:flutter/material.dart';

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
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Text(
        description,
        style: TextStyle(color: warna, fontWeight: FontWeight.bold),
      ),
    );
  }
}
