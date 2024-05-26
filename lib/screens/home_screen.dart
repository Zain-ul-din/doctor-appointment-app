import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:med_app/constants.dart';
import 'package:med_app/screens/loading_screen.dart';
import 'package:med_app/screens/login_screen.dart';
import 'package:med_app/services/auth.dart';
import 'package:med_app/services/firestore.dart';
import 'package:med_app/services/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  late StreamSubscription<User?> _userSubscription;
  User? _user;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _userSubscription = AuthService().user.listen(
      (user) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      },
      onError: (error) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _hasError) {
      return const LoadingScreen();
    }

    return _user == null
        ? LoginScreen()
        : PageView(children: [mainView(context), mainView(context)]);
  }

  Scaffold mainView(BuildContext ctx) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
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
            contentHeader(
              title: "Top Doctors",
              onTap: () {
                Navigator.pushNamed(ctx, '/doctors');
              },
            ),
            FutureBuilder(
              future: FireStoreService().getTopTenDoctors(),
              builder: (ctx, snapShot) {
                if (snapShot.hasError ||
                    snapShot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                // Ensure that snapShot.data is not null
                if (!snapShot.hasData || snapShot.data == null) {
                  return const Center(child: Text("No doctors found"));
                }
                var doctors = snapShot.data!;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 6),
                      ...doctors.map(
                        (doctor) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: doctorCard(
                            model: doctor,
                            onTap: () {
                              Navigator.pushNamed(ctx, '/doctor',
                                  arguments: doctor);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
      bottomNavigationBar: bottomBar(),
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

  Padding contentHeader({required String title, Function? onTap}) {
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
            onTap: () {
              if (onTap != null) onTap();
            },
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

  Widget bottomBar() {
    return GNav(
        gap: 8,
        backgroundColor: Colors.indigoAccent.shade100,
        color: Colors.white,
        activeColor: Colors.indigoAccent.shade200,
        tabBackgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
        tabMargin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.calendar_month,
            text: 'Appointments',
          ),
          GButton(
            icon: Icons.medication_outlined,
            text: 'Medication',
          )
        ]);
  }

  Container header() {
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
      // width: screenSize.width,
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
                onTapOutside: (e) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onTap: () {
                  // tap
                },
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

  InkWell doctorCard({required DoctorModel model, required Function onTap}) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(maxWidth: 300),
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
                    image: DecorationImage(
                      image: NetworkImage(
                        model.photoURL,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.fullName,
                        maxLines: 2,
                        style: kCardTitleStyle.copyWith(height: 1.0),
                      ),
                      Text(
                        "${model.primarySpecialization}, ${model.secondarySpecializations}",
                        style: kSubtitleStyle.copyWith(color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
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
                              "${model.yearOfExperience} Years",
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
                              "0 Patients",
                              style: kSubtitleStyle.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ])
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
