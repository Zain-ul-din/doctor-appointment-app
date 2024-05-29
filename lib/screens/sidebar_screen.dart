import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_app/components/sidebar_row.dart';
import 'package:med_app/constants.dart';
import 'package:med_app/models/sidebar.dart';
import 'package:provider/single_child_widget.dart';

class SidebarScreen extends StatelessWidget {
  final Function onClose;
  final Function onAppointmentIconClick;
  final Function onMedicationIconClick;
  final User currentUser;

  const SidebarScreen(
      {super.key,
      required this.onClose,
      required this.onAppointmentIconClick,
      required this.onMedicationIconClick,
      required this.currentUser});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height,
      width: screenSize.width * 0.75,
      padding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 20.0),
      decoration: const BoxDecoration(
          color: kBackgroundColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(34.0),
          ),
          boxShadow: [
            BoxShadow(
              color: kShadowColor, // Shadow color with opacity
              spreadRadius: 1, // Spread radius
              blurRadius: 10, // Blur radius
              offset: Offset(0, 4), // Offset in x and y direction
            ),
          ]),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(currentUser.photoURL ?? ""),
                    radius: 21.0,
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser.displayName ?? "",
                        style: kTitle2Style,
                      ),
                      Text(
                        currentUser.email ?? "",
                        style: kSubtitleStyle.copyWith(fontSize: 14),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.15,
            ),
            SidebarRow(
              sidebarItem: sidebarItems[0],
              onTap: () {
                onClose();
              },
            ),
            const SizedBox(
              height: 26.0,
            ),
            SidebarRow(
              sidebarItem: sidebarItems[1],
              onTap: () {
                onClose();
                Navigator.pushNamed(context, '/doctors');
              },
            ),
            const SizedBox(
              height: 26.0,
            ),
            SidebarRow(
              sidebarItem: sidebarItems[2],
              onTap: () {
                // appointments
                onAppointmentIconClick();
                onClose();
              },
            ),
            const SizedBox(
              height: 26.0,
            ),
            SidebarRow(
              sidebarItem: sidebarItems[3],
              onTap: () {
                // medication
                onMedicationIconClick();
                onClose();
              },
            ),
            const SizedBox(
              height: 26.0,
            ),
            SidebarRow(
              sidebarItem: sidebarItems[4],
              onTap: () {
                // profile
                onClose();
              },
            ),
            const SizedBox(
              height: 26.0,
            ),
            const Spacer(),
            InkWell(
              onTap: () {},
              child: Ink(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.login,
                        color: Colors.redAccent.shade700,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Logout",
                        style: kTitle2Style.copyWith(
                          color: Colors.redAccent.shade700,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
