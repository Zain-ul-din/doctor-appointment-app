import 'dart:async';

import 'package:flutter/material.dart';
import 'package:med_app/constants.dart';
import 'package:med_app/services/firestore.dart';
import 'package:med_app/services/models.dart';
import 'package:med_app/util.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HealthProviderDetailsScreen extends StatefulWidget {
  final PanelController controller;
  final HealthProviderModel? model;
  final DoctorModel? doctorModel;
  HealthProviderDetailsScreen(
      {Key? key,
      required this.controller,
      required this.model,
      required this.doctorModel})
      : super(key: key);

  @override
  _HealthProviderDetailsScreenState createState() =>
      _HealthProviderDetailsScreenState();
}

class _HealthProviderDetailsScreenState
    extends State<HealthProviderDetailsScreen> {
  late int activeIndex = 0;
  late String activeDay = 'Mon';
  late DateTime _selectedDay = DateTime.now();
  final FireStoreService _fireStoreService = FireStoreService();
  late StreamSubscription<List<AppointmentModel>> _subscription;
  late List<AppointmentModel> _appointments = [];
  late List<AppointmentModel> _reservedAppointments = [];

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    activeDay = getDayOfWeek(now.weekday);
    activeIndex = 0; // No card is initially active
  }

  @override
  void didUpdateWidget(covariant HealthProviderDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.model != null && oldWidget.model!.id != widget.model!.id) {
      _subscription.cancel();
    }

    if (oldWidget.model == null || oldWidget.model!.id != widget.model!.id) {
      _subscription = _fireStoreService
          .streamAppointmentsByHealthProviderId(widget.model!.id)
          .listen((appointments) {
        setState(() {
          _appointments = appointments;
          var weekDay = Util().getWeekDayName(_selectedDay.weekday);
          _reservedAppointments = _appointments.where((appointment) {
            return appointment.weekDay == weekDay;
          }).toList();
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    // Unsubscribe from the stream here
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      backdropColor: kBackgroundColor,
      controller: widget.controller,
      defaultPanelState: PanelState.CLOSED,
      panel: widget.model == null
          ? Container()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 14.0, right: 14.0, bottom: 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  widget.model!.avatar,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  widget.model!.name,
                                  style: kTitle1Style,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.model!.location,
                                  style: const TextStyle(
                                      height: 1, color: Colors.grey),
                                ),
                                const SizedBox(height: 2),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Open Google Maps with the provider's location
                                    // You need to integrate Google Maps in your app and pass the location to it
                                    // For demonstration purposes, I'll just print the location here
                                    print(
                                        'Viewing ${widget.model!.name} on Google Maps');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 0,
                                    ),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    elevation:
                                        1, // Adds a subtle elevation to the button
                                  ),
                                  icon: const Icon(
                                    Icons.map, // Google Maps icon
                                    color: Colors.black,
                                  ),
                                  label: const Text(
                                    "View On Google",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
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
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              activeIndex = index;
                              activeDay = dayOfWeek;
                              _selectedDay = currentDate;

                              var weekDay =
                                  Util().getWeekDayName(currentDate.weekday);
                              _reservedAppointments =
                                  _appointments.where((appointment) {
                                return appointment.weekDay == weekDay;
                              }).toList();
                            });
                          },
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 8,
                              ),
                              scheduleCard(
                                date: formatDate(currentDate),
                                weekName: dayOfWeek,
                                active: index == activeIndex,
                              ),
                              SizedBox(
                                width: index == 6 ? 8 : 0,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 6.0,
                      right: 6.0,
                      top: 6.0,
                      bottom: 14,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14.0,
                        horizontal: 6.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigoAccent.shade100,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              "Time Slots",
                              style: kCardTitleStyle,
                            ),
                          ),
                          widget.model!.getTimeSlots(activeDay).isEmpty
                              ? Expanded(
                                  child: Center(
                                    child: Text(
                                      "Not Available",
                                      style: kCardSubtitleStyle.copyWith(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                )
                              : Wrap(
                                  direction: Axis.horizontal,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  runAlignment: WrapAlignment.spaceBetween,
                                  spacing: 8,
                                  runSpacing: 8,
                                  children:
                                      widget.model!.getTimeSlots(activeDay).map(
                                    (slot) {
                                      var isReserved = _reservedAppointments
                                          .any((appointment) {
                                        return appointment.slot == slot;
                                      });
                                      return GestureDetector(
                                        onTap: () {
                                          if (isReserved) return;
                                          _showConfirmationDialog(
                                            context,
                                            slot,
                                          );
                                        },
                                        child: timeSlotCard(
                                          slot: slot,
                                          active: !isReserved,
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(34),
      ),
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height * 0.8,
    );
  }

  Container timeSlotCard({required String slot, required bool active}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.white60,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        active ? slot : "Busy",
        style: const TextStyle(color: Colors.black),
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

  Container scheduleCard(
      {required String date, required String weekName, required bool active}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: active ? Colors.indigoAccent.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorderColor),
      ),
      child: Column(
        children: [
          Text(
            date,
            style: kCardTitleStyle.copyWith(
              fontSize: 18,
              color: active ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            weekName,
            style: kCardTitleStyle.copyWith(
                fontSize: 18, color: active ? Colors.white : Colors.black),
          )
        ],
      ),
    );
  }

// Method to show the confirmation dialog
  void _showConfirmationDialog(BuildContext context, String slot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kBackgroundColor,
          title: const Text('Confirm Appointment'),
          content: Text(
            'Do you want to confirm your appointment for ${_selectedDay.toLocal().toString().split(' ')[0]} $slot?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Confirm',
              ),
              onPressed: () {
                FireStoreService().createAppointment(
                  doctorModel: widget.doctorModel!,
                  healthProviderModel: widget.model!,
                  selectedSlot: slot,
                  appointmentDate: _selectedDay,
                );
                // Add your appointment confirmation logic here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
}
