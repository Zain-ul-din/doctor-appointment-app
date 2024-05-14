import 'package:flutter/material.dart';
import 'package:med_app/constants.dart';

class DoctorScreen extends StatelessWidget {
  DoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width,
            padding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 14.0,
            ),
            child: SafeArea(
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
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
                          const SizedBox(height: 12.0),
                          Text(
                            "Doctor Name",
                            style: kCardTitleStyle.copyWith(
                                height: 1.0, color: Colors.black),
                          ),
                          Text(
                            "Specialization",
                            style: kBodyLabelStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(14.0),
                      decoration: BoxDecoration(
                          color: Colors.indigoAccent.shade100,
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: Column(
                                children: [
                                  Text(
                                    "350+",
                                    style: kLargeTitleStyle.copyWith(
                                      color: Colors.indigoAccent.shade100,
                                    ),
                                  ),
                                  Text(
                                    "Patients",
                                    style: kSubtitleStyle,
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: Column(
                                children: [
                                  Text(
                                    "350+",
                                    style: kLargeTitleStyle.copyWith(
                                      color: Colors.indigoAccent.shade100,
                                    ),
                                  ),
                                  Text(
                                    "Patients",
                                    style: kSubtitleStyle,
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "350+",
                                    style: kLargeTitleStyle.copyWith(
                                      color: Colors.indigoAccent.shade100,
                                    ),
                                  ),
                                  Text(
                                    "Patients",
                                    style: kSubtitleStyle,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About Doctor",
                          style: kTitle1Style,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
                          style: kSubtitleStyle,
                          textAlign: TextAlign.justify,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 14.0,
            ),
            child: Text(
              "Schedules",
              style: kTitle1Style,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                7,
                (index) {
                  DateTime currentDate = DateTime.now().add(
                    Duration(days: index),
                  );
                  String dayOfWeek = getDayOfWeek(
                    currentDate.weekday,
                  );
                  return Row(
                    children: [
                      const SizedBox(
                        width: 12,
                      ),
                      scheduleCard(
                        date: formatDate(currentDate),
                        weekName: dayOfWeek,
                      ),
                      SizedBox(
                        width: index == 6 ? 12 : 0,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thu";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return "";
    }
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}";
  }

  final List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  Container scheduleCard({required String date, required String weekName}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.indigoAccent.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            date,
            style: kCardTitleStyle.copyWith(
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            weekName,
            style: kCardTitleStyle.copyWith(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
