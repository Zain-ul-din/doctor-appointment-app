import 'package:flutter/material.dart';
import 'package:med_app/models/sidebar.dart';

class SidebarRow extends StatelessWidget {
  const SidebarRow({super.key, required this.sidebarItem});

  final SidebarItem sidebarItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42.0,
          height: 42.0,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            gradient: sidebarItem.background,
          ),
          child: sidebarItem.icon,
        ),
        const SizedBox(
          width: 12,
        ),
        Text(
          sidebarItem.title,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w800,
            color: Color(0xFF242629),
          ),
        ),
      ],
    );
  }
}
