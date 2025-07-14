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
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
      width: MediaQuery.of(context).size.width * 0.42,
      height: MediaQuery.of(context).size.height * 0.18,
      decoration: BoxDecoration(
        color: isDashed ? Colors.transparent : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: MediaQuery.of(context).size.width * 0.08,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.012),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.042,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.008),
          Text(
            '$count $countLabel',
            style: TextStyle(
              color: Colors.white60,
              fontSize: MediaQuery.of(context).size.width * 0.032,
            ),
          ),
        ],
      ),
    );
  }
}
