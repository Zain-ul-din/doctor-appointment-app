import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:med_app/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(screenSize),
            contentHeader(title: "Specialization"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  specializationCard(
                    title: "Gynecologist",
                    imagePath: "assets/images/gynecologist_icon.png",
                  ),
                  const SizedBox(width: 8),
                  specializationCard(
                    title: "Gynecologist",
                    imagePath: "assets/images/heart_icon.png",
                  ),
                  const SizedBox(width: 8),
                  specializationCard(
                    title: "Gynecologist",
                    imagePath: "assets/images/neurology_icon.png",
                  ),
                  const SizedBox(width: 8),
                  specializationCard(
                    title: "Gynecologist",
                    imagePath: "assets/images/stomach_icon.png",
                  ),
                  const SizedBox(width: 8),
                  specializationCard(
                    title: "Gynecologist",
                    imagePath: "assets/images/child_icon.png",
                  ),
                  const SizedBox(width: 8),
                  specializationCard(
                    title: "Gynecologist",
                    imagePath: "assets/images/knee-joint_icon.png",
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            contentHeader(title: "Top Doctors"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  doctorCard(),
                  const SizedBox(width: 8),
                  doctorCard(),
                  const SizedBox(width: 8),
                  doctorCard(),
                  const SizedBox(width: 8),
                  doctorCard(),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  InkWell specializationCard(
      {required String title, required String imagePath}) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.indigoAccent.shade100,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: 60,
              width: 60,
            ),
            const SizedBox(
              height: 6.0,
            ),
            Text(
              title,
              style: kBodyLabelStyle.copyWith(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding contentHeader({required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: kTitle1Style,
          ),
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(4.0),
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(6),
              child: Text(
                "See All",
                style: kSubtitleStyle,
              ),
            ),
          )
        ],
      ),
    );
  }

  Container header(Size screenSize) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigoAccent.shade100,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 14.0,
        horizontal: 14.0,
      ),
      width: screenSize.width,
      child: SafeArea(
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.sort_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 21,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.network(
                        "https://lh3.googleusercontent.com/a/AEdFTp51aSu5nYW6h8vlrI1oIfCJHBYRjNwWq3MP2RWa=s96-c",
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back",
                      style: kSubtitleStyle.copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Let's find\nyour top doctors!",
                      style: kLargeTitleStyle.copyWith(
                        color: Colors.white,
                        fontSize: 36.0,
                        height: 1,
                      ),
                    )
                  ],
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for doctors...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell doctorCard() {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.indigoAccent.shade100,
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                const SizedBox(width: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Doctor name",
                      maxLines: 2,
                      style: kCardTitleStyle.copyWith(height: 1.0),
                    ),
                    Text(
                      "specialization",
                      style: kSubtitleStyle.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow),
                        Text(
                          "4.5",
                          style: kBodyLabelStyle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(children: [
                      Column(
                        children: [
                          const Text(
                            "Experience",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "8 Years",
                            style: kSubtitleStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          const Text(
                            "Patients",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "8 Years",
                            style: kSubtitleStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ])
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
