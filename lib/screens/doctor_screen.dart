import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:med_app/constants.dart';
import 'package:med_app/services/firestore.dart';
import 'package:med_app/services/models.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DoctorScreen();
}

class _DoctorScreen extends State<DoctorScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> healthProvidersListener;

  @override
  Widget build(BuildContext context) {
    final doctor = ModalRoute.of(context)!.settings.arguments as DoctorModel;
    healthProvidersListener =
        FireStoreService().streamHealthProvidersByDoctorId(doctor.userId);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
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
                              doctor.fullName,
                              style: kCardTitleStyle.copyWith(
                                  height: 1.0, color: Colors.black),
                            ),
                            Text(
                              "${doctor.primarySpecialization}, ${doctor.secondarySpecializations}",
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
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 14.0,
              ),
              child: Text(
                "Health Providers",
                style: kTitle1Style,
              ),
            ),
            StreamBuilder(
                stream: FireStoreService()
                    .streamHealthProvidersByDoctorId(doctor.userId),
                builder: (ctx, snapShot) {
                  if (snapShot.hasError ||
                      snapShot.connectionState == ConnectionState.waiting ||
                      snapShot.data == null) {
                    return const CircularProgressIndicator();
                  }

                  var data = snapShot.data!;
                  var healthProviders =
                      FireStoreService().healthProvidersFromSnapshot(data);

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...healthProviders.map(
                          (provider) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: healthProviderCard(model: provider),
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ],
        ),
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

  Widget healthProviderCard({required HealthProviderModel model}) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
              color: Colors.indigoAccent.shade100,
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/images/hospital.svg",
                width: 30,
                height: 30,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    style: kCardTitleStyle.copyWith(height: 1),
                  ),
                  Text(
                    model.location,
                    style: TextStyle(color: Colors.grey.shade200),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.watch_later_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        "${model.startTime} - ${model.endTime}",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

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

/*
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
*/