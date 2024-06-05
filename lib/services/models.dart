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
  String displayName;
  double rating;
  final List<String> specialization;
  final List<String> locations;

  DoctorModel(
      {required this.title,
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
      required this.locations,
      required this.specialization,
      this.isVerified,
      this.isRejected,
      this.rejectionReason,
      required this.displayName,
      required this.rating});

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
        title: json['title'],
        fullName: json['fullName'],
        rating: json['rating'] + 0.0,
        yearOfExperience: json['yearOfExperience'],
        primarySpecialization: json['primarySpecialization'],
        secondarySpecializations: json['secondarySpecializations'],
        conditionsTreated: List<String>.from(json['conditionsTreated']),
        locations: List<String>.from(json['locations']),
        specialization: List<String>.from(json['specialization']),
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
        displayName: json['displayName']);
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
      'displayName': displayName,
      'rating': rating
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
  late String avatar;
  late String startTime;
  late String endTime;
  late int waitTime;
  late String googleLocLink;
  late List<String> monday;
  late List<String> tuesday;
  late List<String> wednesday;
  late List<String> thursday;
  late List<String> friday;
  late List<String> saturday;
  late List<String> sunday;
  late Timestamp createdAt;
  late Timestamp updatedAt;
  late String location;

  List<String> getTimeSlots(String day) {
    switch (day) {
      case 'Mon':
        return monday;
      case 'Tue':
        return tuesday;
      case 'Wed':
        return wednesday;
      case 'Thu':
        return thursday;
      case 'Fri':
        return friday;
      case 'Sat':
        return saturday;
      case 'Sun':
        return sunday;
      default:
        return [];
    }
  }

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
    required this.avatar,
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
      avatar: data['avatar'],
      googleLocLink: data['googleLocLink'],
      monday: (data['monday'] as List<dynamic>).cast<String>(),
      tuesday: (data['tuesday'] as List<dynamic>).cast<String>(),
      wednesday: (data['wednesday'] as List<dynamic>).cast<String>(),
      thursday: (data['tuesday'] as List<dynamic>).cast<String>(),
      friday: (data['friday'] as List<dynamic>).cast<String>(),
      saturday: (data['saturday'] as List<dynamic>).cast<String>(),
      sunday: (data['sunday'] as List<dynamic>).cast<String>(),
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

@JsonSerializable()
class AppointmentModel {
  String patientId;
  String patientName;
  String doctorId;
  String doctorDisplayName;
  String doctorAvatar;
  String healthProviderId;
  String healthProviderLocation;
  String healthProviderName;
  String healthProviderAvatar;
  String slot;
  String weekDay;
  Timestamp createdAt;
  String status;
  Timestamp appointmentDate;

  AppointmentModel({
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorDisplayName,
    required this.doctorAvatar,
    required this.healthProviderId,
    required this.healthProviderLocation,
    required this.healthProviderName,
    required this.healthProviderAvatar,
    required this.slot,
    required this.weekDay,
    required this.createdAt,
    required this.status,
    required this.appointmentDate,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      patientId: json['patient_id'],
      patientName: json['patient_name'],
      doctorId: json['doctor_id'],
      doctorDisplayName: json['doctor_display_name'],
      doctorAvatar: json['doctor_avatar'],
      healthProviderId: json['health_provider_id'],
      healthProviderLocation: json['health_provider_location'],
      healthProviderName: json['health_provider_name'],
      healthProviderAvatar: json['health_provider_avatar'],
      slot: json['slot'],
      weekDay: json['week_day'],
      createdAt: json['createdAt'] ?? Timestamp.now(),
      status: json['status'],
      appointmentDate: json['appointment_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'patient_name': patientName,
      'doctor_id': doctorId,
      'doctor_display_name': doctorDisplayName,
      'doctor_avatar': doctorAvatar,
      'health_provider_id': healthProviderId,
      'health_provider_location': healthProviderLocation,
      'health_provider_name': healthProviderName,
      'health_provider_avatar': healthProviderAvatar,
      'slot': slot,
      'week_day': weekDay,
      'created_at': createdAt,
      'status': status,
      'appointment_date': appointmentDate,
    };
  }
}

class MessageDoc {
  final String message;
  final String senderId;
  final String senderName;
  final Timestamp timestamp;
  final String type;
  final String sender;

  MessageDoc({
    required this.message,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
    required this.type,
    required this.sender,
  });

  factory MessageDoc.fromJson(Map<String, dynamic> json) {
    return MessageDoc(
      message: json['message'],
      senderId: json['sender_id'],
      senderName: json['sender_name'],
      timestamp: json['timestamp'],
      type: json['type'],
      sender: json['sender'],
    );
  }
}

class MedicationDoc {
  String name;
  int duration;
  String description;
  String doctorId;
  Timestamp createdAt;
  Timestamp updatedAt;
  Map<String, Map<String, List<Variant>>> variants;
  Map<String, dynamic> days;
  bool? isPublic;
  String uid;
  List<String> subscribers;

  MedicationDoc({
    required this.name,
    required this.duration,
    required this.description,
    required this.doctorId,
    required this.createdAt,
    required this.updatedAt,
    required this.variants,
    required this.days,
    this.isPublic,
    required this.uid,
    required this.subscribers,
  });

  factory MedicationDoc.fromJson(Map<String, dynamic> json) {
    Map<String, Map<String, List<Variant>>> variants = {};
    json['variants'].forEach((key, value) {
      Map<String, List<Variant>> timeMap = {};
      value.forEach((time, variantList) {
        timeMap[time] = List<Variant>.from(
            variantList.map((variant) => Variant.fromJson(variant)));
      });
      variants[key] = timeMap;
    });

    return MedicationDoc(
      name: json['name'],
      duration: json['duration'],
      description: json['description'],
      doctorId: json['doctor_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      variants: variants,
      days: json['days'],
      isPublic: json['public'],
      uid: json['uid'],
      subscribers: List<String>.from(json['subscribers']),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, Map<String, dynamic>> variantsJson = {};
    variants.forEach((key, value) {
      Map<String, List<Map<String, dynamic>>> timeMap = {};
      value.forEach((time, variantList) {
        timeMap[time] = variantList.map((variant) => variant.toJson()).toList();
      });
      variantsJson[key] = timeMap;
    });

    return {
      'name': name,
      'duration': duration,
      'description': description,
      'doctor_id': doctorId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'variants': variantsJson,
      'days': days,
      'public': isPublic,
      'uid': uid,
      'subscribers': subscribers,
    };
  }
}

class Variant {
  String name;
  int qt;

  Variant({
    required this.name,
    required this.qt,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      name: json['name'],
      qt: json['qt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'qt': qt,
    };
  }
}

enum MessageType { activity, conversation, proposal }

enum SenderType { patient, doctor }

class ChatMessageDoc {
  String doctorAvatar;
  String doctorDisplayName;
  String patientAvatar;
  String patientId;
  String patientName;
  Timestamp timestamp;
  String uid;

  ChatMessageDoc({
    required this.doctorAvatar,
    required this.doctorDisplayName,
    required this.patientAvatar,
    required this.patientId,
    required this.patientName,
    required this.timestamp,
    required this.uid,
  });

  factory ChatMessageDoc.fromJson(Map<String, dynamic> json) {
    return ChatMessageDoc(
      doctorAvatar: json['doctor_avatar'],
      doctorDisplayName: json['doctor_display_name'],
      patientAvatar: json['patient_avatar'],
      patientId: json['patient_id'],
      patientName: json['patient_name'],
      timestamp: json['timestamp'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctor_avatar': doctorAvatar,
      'doctor_display_name': doctorDisplayName,
      'patient_avatar': patientAvatar,
      'patient_id': patientId,
      'patient_name': patientName,
      'timestamp': timestamp,
      'uid': uid,
    };
  }
}
