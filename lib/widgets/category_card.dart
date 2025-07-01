import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final bool isDashed;
  final String countLabel;

  const CategoryCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    this.isDashed = false,
    this.countLabel = 'notes',
  });

  @override
  Widget build(BuildContext context) {
    final border = isDashed
        ? Border.all(color: Colors.white30, width: 1, style: BorderStyle.solid)
        : Border.all(color: Colors.transparent);

    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(16),
      width: 170,
      height: 130,
      decoration: BoxDecoration(
        color: isDashed ? Colors.transparent : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$count $countLabel',
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
