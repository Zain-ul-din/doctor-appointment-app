import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DoctorModel {
  String title;
  String fullName;
  String yearOfExperience;
  String primarySpecialization;
  String secondarySpecializations;
  List<String> conditionsTreated;
  String pmdcRegistrationNumber;
  String userId;
  Timestamp createdAt;
  Timestamp updatedAt;
  String phoneNumber;
  String email;
  String photoURL;
  String markdown;
  bool? isVerified;
  bool? isRejected;
  String? rejectionReason;

  DoctorModel({
    required this.title,
    required this.fullName,
    required this.yearOfExperience,
    required this.primarySpecialization,
    required this.secondarySpecializations,
    required this.conditionsTreated,
    required this.pmdcRegistrationNumber,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.phoneNumber,
    required this.email,
    required this.photoURL,
    required this.markdown,
    this.isVerified,
    this.isRejected,
    this.rejectionReason,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      title: json['title'],
      fullName: json['fullName'],
      yearOfExperience: json['yearOfExperience'],
      primarySpecialization: json['primarySpecialization'],
      secondarySpecializations: json['secondarySpecializations'],
      conditionsTreated: List<String>.from(json['conditionsTreated']),
      pmdcRegistrationNumber: json['pmdcRegistrationNumber'],
      userId: json['userId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      photoURL: json['photoURL'],
      markdown: json['markdown'],
      isVerified: json['isVerified'],
      isRejected: json['isRejected'],
      rejectionReason: json['rejectionReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'fullName': fullName,
      'yearOfExperience': yearOfExperience,
      'primarySpecialization': primarySpecialization,
      'secondarySpecializations': secondarySpecializations,
      'conditionsTreated': conditionsTreated,
      'pmdcRegistrationNumber': pmdcRegistrationNumber,
      'userId': userId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'phone_number': phoneNumber,
      'email': email,
      'photoURL': photoURL,
      'markdown': markdown,
      'isVerified': isVerified,
      'isRejected': isRejected,
      'rejectionReason': rejectionReason,
    };
  }
}

@JsonSerializable()
class HealthProviderModel {
  late String name;
  late String id;
  late String doctorId;
  late String about;
  late String city;
  late String startTime;
  late String endTime;
  late int waitTime;
  late String googleLocLink;
  late List<Map<String, String>> monday;
  late List<Map<String, String>> tuesday;
  late List<Map<String, String>> wednesday;
  late List<Map<String, String>> thursday;
  late List<Map<String, String>> friday;
  late List<Map<String, String>> saturday;
  late List<Map<String, String>> sunday;
  late Timestamp createdAt;
  late Timestamp updatedAt;
  late String location;

  HealthProviderModel({
    required this.id,
    required this.doctorId,
    required this.about,
    required this.city,
    required this.startTime,
    required this.endTime,
    required this.waitTime,
    required this.googleLocLink,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.location,
  });

  factory HealthProviderModel.fromFirestore(Map<String, dynamic> data) {
    return HealthProviderModel(
      name: data['name'],
      location: data['location'],
      id: data['uid'],
      doctorId: data['doctor_id'],
      about: data['about'],
      city: data['city'],
      startTime: data['start_time'],
      endTime: data['end_time'],
      waitTime: data['wait_time'],
      googleLocLink: data['googleLocLink'],
      monday: (data['monday'] as List<dynamic>).cast<Map<String, String>>(),
      tuesday: (data['tuesday'] as List<dynamic>).cast<Map<String, String>>(),
      wednesday:
          (data['wednesday'] as List<dynamic>).cast<Map<String, String>>(),
      thursday: (data['thursday'] as List<dynamic>).cast<Map<String, String>>(),
      friday: (data['friday'] as List<dynamic>).cast<Map<String, String>>(),
      saturday: (data['saturday'] as List<dynamic>).cast<Map<String, String>>(),
      sunday: (data['sunday'] as List<dynamic>).cast<Map<String, String>>(),
      createdAt: data['created_at'] as Timestamp,
      updatedAt: data['updated_at'] as Timestamp,
    );
  }

  // Helper method to parse time string into hours and minutes
  static Map<String, int> parseTime(String time) {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return {'hours': hours, 'minutes': minutes};
  }
}
