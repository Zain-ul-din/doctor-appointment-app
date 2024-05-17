import 'package:flutter/material.dart';
import 'package:med_app/constants.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(
              12.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: const Offset(0, 0.5), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IntrinsicHeight(
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // Adjust the radius as needed
                          image: const DecorationImage(
                            image: NetworkImage(
                              "https://source.unsplash.com/random/100x100",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          Text(
                            "4.5",
                            style: kBodyLabelStyle.copyWith(
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                // create one card here doctor
                IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dr. John Doe",
                        style: kTitle1Style,
                      ),
                      Text(
                        "Specilization",
                        style: kSubtitleStyle,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fmd_good_outlined,
                            color: Colors.grey.shade700,
                            size: 14,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            "Lahore Jhor town ",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
