import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_app/components/medication_card.dart';
import 'package:med_app/constants.dart';
import 'package:med_app/services/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:med_app/util.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  late int activeIndex = 0;
  late String activeDay = '';
  late DateTime _selectedDay = DateTime.now();
  List<DateTime> _dateRange = [];

  late LocalStorageService _localStorageService;
  late DateTime _startDate;
  late DateTime _lastDate;

  @override
  void initState() {
    super.initState();
    // _localStorageService = LocalStorageService();
    // _initializeMedicationData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localStorageService = LocalStorageService();
    _initializeMedicationData();
  }

  Future<void> _initializeMedicationData() async {
    final medication =
        ModalRoute.of(context)!.settings.arguments as MedicationDoc;
    final medicationData = await _localStorageService.readData();

    if (medicationData.containsKey(medication.uid)) {
      final data = medicationData[medication.uid];
      _startDate = DateTime.parse(data['startDate']);
      _lastDate = DateTime.parse(data['lastDate']);
      _dateRange = _getDateRange(_startDate, _lastDate);
      setState(() {
        _selectedDay = DateTime.now();
        activeIndex =
            _dateRange.indexWhere((day) => day.day == _selectedDay.day);
        activeDay = Util().getWeekDayName(_selectedDay.weekday);
      });
    } else {
      print("Start date or end date not found in local storage.");
    }
  }

  List<DateTime> _getDateRange(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final medication =
        ModalRoute.of(context)!.settings.arguments as MedicationDoc;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(medication.name, style: kCardTitleStyle),
        backgroundColor: Colors.indigoAccent.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 0),
        child: Column(
          children: [
            _dateRange.isNotEmpty
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        _dateRange.length,
                        (index) {
                          DateTime currentDate = _dateRange[index];
                          String dayOfWeek =
                              Util().getWeekDayName(currentDate.weekday);
                          return GestureDetector(
                            onTap: () {
                              print("idx: " + index.toString());
                              setState(() {
                                activeIndex = index;
                                activeDay = dayOfWeek;
                                _selectedDay = currentDate;
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
                                  width: index == _dateRange.length - 1 ? 8 : 0,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Center(child: Text("Loading dates...")),
            // Additional medication details can be displayed here
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _renderMedicationForSelectedDay(medication),
                      const SizedBox(height: 16)
                      // Add more medication details here
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderMedicationForSelectedDay(MedicationDoc doc) {
    final selectedDayMedication = doc.days[(activeIndex + 1).toString()]
        as String?; // Get the selected day

    if (selectedDayMedication == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Center(child: Text('No Medication today')),
      );
    }

    final variantsForSelectedDay = doc.variants[selectedDayMedication];

    // Sort the time slots by time
    final sortedTimeSlots = variantsForSelectedDay?.keys.toList() ?? [];
    sortedTimeSlots.sort((a, b) {
      final aTime = DateFormat('HH:mm').parse(a);
      final bTime = DateFormat('HH:mm').parse(b);
      return aTime.compareTo(bTime);
    });

    // Render the medication for the selected day
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // Render variants using ListView.builder
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // Disable scrolling
            itemCount: sortedTimeSlots.length,
            itemBuilder: (context, index) {
              final timeKey = sortedTimeSlots[index];
              final formattedTime = DateFormat('hh:mm a').format(
                DateFormat('HH:mm').parse(timeKey),
              );
              final variants = variantsForSelectedDay?[timeKey ?? ''];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.watch_later_outlined),
                        const SizedBox(width: 4),
                        Text(
                          formattedTime ?? '',
                          style: kTitle1Style,
                        ),
                      ],
                    ),
                  ),
                  // Render the list of variants for the current time
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: variants?.map((variant) {
                          return _buildVariantCard(variant);
                        }).toList() ??
                        [],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVariantCard(Variant variant) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24), // Rounded border
      ),
      color: Colors.indigoAccent.shade100, // Set the background color to indigo
      child: ListTile(
        title: Text(
          variant.name,
          style:
              const TextStyle(color: Colors.white), // Set text color to white
        ),
        subtitle: Text(
          'Quantity: ${variant.qt}',
          style:
              const TextStyle(color: Colors.white), // Set text color to white
        ),
        trailing: IconButton(
          icon: Icon(Icons.check),
          color: Colors.white, // Set icon color to white
          onPressed: () {
            // Add functionality to handle adding variant to medication
          },
        ),
        tileColor: Colors.indigoAccent
            .shade100, // Set the background color of the ListTile itself
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 6), // Adjust padding as needed
      ),
    );
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}";
  }

  Container scheduleCard({
    required String date,
    required String weekName,
    required bool active,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: active ? Colors.indigoAccent.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          Text(
            date,
            style: TextStyle(
              fontSize: 18,
              color: active ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            weekName,
            style: TextStyle(
              fontSize: 18,
              color: active ? Colors.white : Colors.black,
            ),
          )
        ],
      ),
    );
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
