import 'package:flutter/material.dart';
import 'package:med_app/models/sidebar.dart';

class SidebarRow extends StatelessWidget {
  final Function onTap;
  final SidebarItem sidebarItem;

  const SidebarRow({super.key, required this.sidebarItem, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onTap();
        },
        splashColor: Colors.grey.withOpacity(0.05),
        highlightColor: Colors.grey.withOpacity(0.01),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 0),
          child: Row(
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
          ),
        ),
      ),
    );
  }
}
