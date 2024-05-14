import 'package:flutter/material.dart';
import 'package:med_app/components/sidebar_row.dart';
import 'package:med_app/constants.dart';
import 'package:med_app/models/sidebar.dart';

class SidebarScreen extends StatelessWidget {
  const SidebarScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height,
      width: screenSize.width * 0.85,
      padding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 20.0),
      decoration: const BoxDecoration(
        color: kSidebarBackgroundColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(34.0),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage("/assets/foo"),
              radius: 21.0,
            ),
            SizedBox(
              height: screenSize.height * 0.15,
            ),
            SidebarRow(
              sidebarItem: sidebarItems[0],
            ),
            const SizedBox(
              height: 32.0,
            ),
            SidebarRow(
              sidebarItem: sidebarItems[1],
            ),
            const SizedBox(
              height: 32.0,
            ),
            SidebarRow(
              sidebarItem: sidebarItems[2],
            ),
            const SizedBox(
              height: 32.0,
            ),
            SidebarRow(
              sidebarItem: sidebarItems[3],
            ),
            const SizedBox(
              height: 32.0,
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  "Logout",
                  style: kSecondaryCalloutLabelStyle,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
