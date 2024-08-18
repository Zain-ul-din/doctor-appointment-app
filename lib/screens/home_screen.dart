import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:med_app/components/appointment_card.dart';
import 'package:med_app/components/medication_card.dart';
import 'package:med_app/constants.dart';
import 'package:med_app/screens/loading_screen.dart';
import 'package:med_app/screens/login_screen.dart';
import 'package:med_app/screens/sidebar_screen.dart';
import 'package:med_app/services/auth.dart';
import 'package:med_app/services/firestore.dart';
import 'package:med_app/services/models.dart';
import 'package:med_app/shared/DoctorsFilter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription<User?> _userSubscription;
  User? _user;
  bool _isLoading = true;
  bool _hasError = false;
  late PageController _pageController;
  int _selectedIndex = 0;
  late Future<List<DoctorModel>> _doctorsFuture;
  late StreamSubscription<List<AppointmentModel>> _appointmentsSubscription;
  List<AppointmentModel> _appointments = [];
  bool _appointmentsLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late StreamSubscription<List<MedicationDoc>> _medicationsSubscription;
  List<MedicationDoc> _medications = [];
  bool _medicationsLoading = true;

  bool _showLoginScreen = true;
  bool _initialNavigationHandled = false;

  @override
  void initState() {
    super.initState();

    // final doctor = ModalRoute.of(context)!.settings.arguments as DoctorModel;

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
    _appointmentsSubscription = FireStoreService()
        .streamAppointmentsByPatientId()
        .listen((appointments) {
      setState(() {
        _appointments = appointments;
        _appointmentsLoading = false;
      });
    }, onError: (error) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    });
    _doctorsFuture = FireStoreService().getTopTenDoctors();

    // Subscribe to medication documents stream
    _medicationsSubscription =
        FireStoreService().streamMedicationsByUserId().listen((medications) {
      setState(() {
        _medications = medications;
        _medicationsLoading = false;
      });
    }, onError: (error) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    });

    // Set a timer to show the login screen for a specified duration
    Timer(const Duration(seconds: 5), () {
      setState(() {
        _showLoginScreen = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialNavigationHandled) {
      final int activeScreen =
          ModalRoute.of(context)!.settings.arguments as int? ?? -1;
      if (activeScreen != -1) {
        setState(() {
          _showLoginScreen = false;
          _selectedIndex = activeScreen;
        });

        _pageController = PageController(initialPage: activeScreen);

        _initialNavigationHandled = true;
      } else {
        _pageController = PageController(initialPage: 0);
      }
    }
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    _appointmentsSubscription.cancel();
    _pageController.dispose();
    _medicationsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _hasError) {
      return const LoadingScreen();
    }

    return _showLoginScreen || _user == null
        ? LoginScreen(
            hideLoginButton: _user != null,
          )
        : Scaffold(
            key: _scaffoldKey,
            drawer: SidebarScreen(
              currentUser: _user as User,
              onAppointmentIconClick: () {
                setState(() {
                  _selectedIndex = 1;
                });
                _pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 50),
                  curve: Curves.ease,
                );
                _pageController.jumpToPage(1);
              },
              onMedicationIconClick: () {
                setState(() {
                  _selectedIndex = 2;
                });
                _pageController.animateToPage(
                  2,
                  duration: const Duration(milliseconds: 50),
                  curve: Curves.ease,
                );
                _pageController.jumpToPage(2);
              },
              onClose: () {
                if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
                  Navigator.of(context).pop();
                }
              },
            ),
            body: Stack(children: [
              GestureDetector(
                onTap: () {
                  if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
                    Navigator.of(context).pop();
                  }
                },
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  children: [
                    mainView(context),
                    appointmentsView(context, _appointments),
                    medicationView(context, _medications),
                  ],
                ),
              )
            ]),
            bottomNavigationBar: bottomBar(),
          );
  }

  bool firstRender = true;

  Scaffold mainView(BuildContext ctx) {
    if (firstRender) {
      firstRender = false;
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(ctx),
            contentHeader(
                title: "Specialization",
                onTap: () {
                  Navigator.pushNamed(ctx, '/doctors');
                }),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  specializationCard(
                    context: context,
                    title: "Gynecologist",
                    imagePath: "assets/images/gynecologist_icon.png",
                  ),
                  const SizedBox(width: 8),
                  specializationCard(
                    context: context,
                    title: "Cardiologist",
                    imagePath: "assets/images/heart_icon.png",
                  ),
                  const SizedBox(width: 8),
                  specializationCard(
                    context: context,
                    title: "Neurologist",
                    imagePath: "assets/images/neurology_icon.png",
                  ),
                  const SizedBox(width: 8),
                  specializationCard(
                    context: context,
                    title: "Gastroenterologist",
                    imagePath: "assets/images/stomach_icon.png",
                  ),
                  const SizedBox(width: 8),
                  specializationCard(
                    context: context,
                    title: "Pediatrician",
                    imagePath: "assets/images/child_icon.png",
                  ),
                  const SizedBox(width: 8),
                  specializationCard(
                    context: context,
                    title: "Orthodontist",
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
            FutureBuilder<List<DoctorModel>>(
              future: _doctorsFuture,
              builder: (ctx, snapShot) {
                if (snapShot.hasError ||
                    snapShot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
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
    );
  }

  Scaffold appointmentsView(
      BuildContext ctx, List<AppointmentModel> appointments) {
    return Scaffold(
        backgroundColor: Colors.indigoAccent.shade100,
        appBar: AppBar(
          backgroundColor: Colors.indigoAccent.shade100,
          title: Text(
            "Appointments",
            style: kCardTitleStyle,
          ),
        ),
        body: _appointmentsLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : appointments.isEmpty
                ? Center(
                    child: Text(
                      "No Appointments",
                      style: kTitle1Style.copyWith(color: Colors.white),
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: appointments.map((appointment) {
                        return AppointmentCard(appointment: appointment);
                      }).toList(),
                    ),
                  ));
  }

  Scaffold medicationView(BuildContext ctx, List<MedicationDoc> medications) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent.shade100,
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent.shade100,
        title: Text(
          "Medications",
          style: kCardTitleStyle,
        ),
      ),
      body: _medicationsLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : medications.isEmpty
              ? Center(
                  child: Text(
                    "No Medications",
                    style: kTitle1Style.copyWith(color: Colors.white),
                  ),
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: medications.map((medication) {
                        return MedicationCard(
                          medication: medication,
                        );
                        // return MedicationCard(medication: medication);
                      }).toList(),
                    ),
                  ),
                ),
    );
  }

  InkWell specializationCard(
      {required String title,
      required String imagePath,
      required BuildContext context}) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/doctors',
          arguments: DoctorsFilter(specialization: title.toLowerCase()),
        );
      },
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
      selectedIndex: _selectedIndex,
      onTabChange: (index) {
        setState(() {
          _selectedIndex = index;
        });
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
        );
        _pageController.jumpToPage(index);
      },
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
        ),
      ],
    );
  }

  Container header(BuildContext context) {
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
      child: SafeArea(
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
                        Navigator.of(context).pop();
                      } else {
                        _scaffoldKey.currentState?.openDrawer();
                      }
                    },
                    icon: const Icon(
                      Icons.sort_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () async {
                        final Uri _url =
                            Uri.parse('https://fyp-web-three.vercel.app/');
                        if (!await launchUrl(_url)) {
                          throw Exception('Could not launch $_url');
                        }
                      },
                      child: const Text(
                        "Join As a Doctor",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Adjust the value to make it less rounded
                        ),
                      )),
                  const SizedBox(
                    width: 12,
                  ),
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
                  Navigator.pushNamed(context, '/doctors',
                      arguments: DoctorsFilter(showFilter: true));
                },
                readOnly: true,
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
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(model.photoURL),
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
                        model.displayName,
                        maxLines: 2,
                        style: kCardTitleStyle.copyWith(height: 1.0),
                      ),
                      Text(
                        "${model.primarySpecialization}, ${model.secondarySpecializations}",
                        style: kSubtitleStyle.copyWith(color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          Text(
                            "${model.rating}",
                            style: kBodyLabelStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
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
                          const SizedBox(width: 20),
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
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
