import 'package:flutter/material.dart';

class SidebarItem {
  late String title;
  late LinearGradient background;
  late Icon icon;

  SidebarItem(
      {required this.title, required this.background, required this.icon});
}

var sidebarItems = [
  SidebarItem(
    title: "Home",
    background: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF00AEFF),
        Color(0xFF0076FF),
      ],
    ),
    icon: const Icon(
      Icons.home,
      color: Colors.white,
    ),
  ),
  SidebarItem(
    title: "Doctors",
    background: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFA7d75), Color(0xFFC23D61)]),
    icon: const Icon(
      Icons.local_hospital,
      color: Colors.white,
    ),
  ),
  SidebarItem(
    title: "Appointments",
    background: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF36D1DC),
          Color(0xFF5B86E5),
        ]),
    icon: const Icon(
      Icons.calendar_month,
      color: Colors.white,
    ),
  ),
  SidebarItem(
    title: "Medications",
    background: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFAD64A), Color(0xFFEA880F)]),
    icon: const Icon(
      Icons.medication_liquid_outlined,
      color: Colors.white,
    ),
  ),
  SidebarItem(
    title: "Profile",
    background: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4E62CC), Color(0xFF202A78)],
    ),
    icon: const Icon(
      Icons.person,
      color: Colors.white,
    ),
  ),
];
