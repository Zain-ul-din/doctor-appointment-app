import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_app/services/firestore.dart';
import 'package:med_app/services/models.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  static const String _fileName = "medication_data.json";

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_fileName';
  }

  Future<Map<String, dynamic>> readData() async {
    try {
      final path = await _getFilePath();
      final file = File(path);

      if (await file.exists()) {
        final contents = await file.readAsString();
        return json.decode(contents) as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error reading data: $e");
    }

    return {};
  }

  Future<void> writeData(Map<String, dynamic> data) async {
    try {
      final path = await _getFilePath();
      final file = File(path);
      await file.writeAsString(json.encode(data));
    } catch (e) {
      print("Error writing data: $e");
    }
  }
}

class MedicationCard extends StatefulWidget {
  final MedicationDoc medication;

  const MedicationCard({Key? key, required this.medication}) : super(key: key);

  @override
  _MedicationCardState createState() => _MedicationCardState();
}

class _MedicationCardState extends State<MedicationCard> {
  late LocalStorageService _localStorageService;
  late DateTime _startDate = DateTime.now();
  late DateTime _lastDate = DateTime.now();

  DoctorModel? _doctor;

  @override
  void initState() {
    super.initState();
    _localStorageService = LocalStorageService();
    _initializeMedicationData();
    _fetchDoctorDetails();
  }

  Future<void> _fetchDoctorDetails() async {
    try {
      DoctorModel doctor =
          await FireStoreService().getDoctorById(widget.medication.doctorId);
      setState(() {
        _doctor = doctor;
      });
    } catch (e) {
      print("Error fetching doctor details: $e");
    }
  }

  Future<void> _initializeMedicationData() async {
    final medicationData = await _localStorageService.readData();
    if (medicationData.containsKey(widget.medication.uid)) {
      final data = medicationData[widget.medication.uid];
      _startDate = DateTime.parse(data['startDate']);
      _lastDate = DateTime.parse(data['lastDate']);
    } else {
      _startDate = DateTime.now();
      _lastDate = _startDate.add(Duration(days: widget.medication.duration));
      medicationData[widget.medication.uid] = {
        'startDate': _startDate.toIso8601String(),
        'lastDate': _lastDate.toIso8601String(),
      };
      await _localStorageService.writeData(medicationData);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_startDate == null || _lastDate == null) {
      return CircularProgressIndicator();
    }

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: _doctor != null
              ? Image.network(
                  _doctor!
                      .photoURL, // Assuming MedicationDoc has an imageUrl field
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
              : const Text(''),
        ),
        title: Text(
          widget.medication.name, // Assuming MedicationDoc has a name field
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_doctor != null) ...[
              Text(
                'Created by: ${_doctor!.fullName}',
                style: const TextStyle(fontSize: 12.0),
              ),
              const SizedBox(height: 2.0),
            ],
            Text(
              'Start Date: ${DateFormat.yMMMd().format(_startDate)}',
              style: const TextStyle(fontSize: 12.0),
            ),
            Text(
              'End Date: ${DateFormat.yMMMd().format(_lastDate)}',
              style: const TextStyle(fontSize: 12.0),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
