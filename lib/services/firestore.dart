import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:med_app/services/auth.dart';
import 'package:med_app/services/models.dart';
import 'package:med_app/util.dart';

class FireStoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<DoctorModel>> getTopTenDoctors() async {
    try {
      var ref = _db
          .collection('doctors')
          .orderBy('rating', descending: true)
          .limit(10);
      var snapshot = await ref.get();
      var doctors =
          snapshot.docs.map((doc) => DoctorModel.fromJson(doc.data()));
      return doctors.toList();
    } catch (error) {
      // Handle error
      throw Exception('Error fetching top ten doctors: $error');
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamHealthProvidersByDoctorId(
      String doctorId) {
    var res = _db
        .collection('health_providers')
        .where('doctor_id', isEqualTo: doctorId)
        .snapshots();
    return res;
  }

  List<HealthProviderModel> healthProvidersFromSnapshot(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    return snapshot.docs.map((doc) {
      return HealthProviderModel.fromFirestore(doc.data());
    }).toList();
  }

  Stream<List<AppointmentModel>> streamAppointmentsByPatientId() {
    // Get the current logged-in user
    final currentUser = AuthService().getUser;

    // Check if user is logged in
    if (currentUser != null) {
      // Stream appointments where patient_id matches current user's ID
      return _db
          .collection('appointments')
          .where('patient_id', isEqualTo: currentUser.uid)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => AppointmentModel.fromJson(doc.data()))
              .toList());
    } else {
      // If user is not logged in, return an empty stream
      return Stream.value([]);
    }
  }

  // Future<QuerySnapshot> getDoctorsWithPagination(
  //   DocumentSnapshot? lastDocument, {
  //   String? location,
  //   String? specialization,
  // }) async {
  //   Query query =
  //       _db.collection('doctors').orderBy('rating', descending: true).limit(30);
  //   List<QuerySnapshot<Map<String, dynamic>>> querySnapshots = [];

  //   if ((location != null && location.isNotEmpty) &&
  //       (specialization != null && specialization.isNotEmpty)) {
  //     // Create separate queries for specialization and location
  //     Query<Map<String, dynamic>> specializationQuery = _db
  //         .collection('doctors')
  //         .where('specialization', arrayContains: specialization);
  //     Query<Map<String, dynamic>> locationQuery = _db
  //         .collection('doctors')
  //         .where('locations', arrayContainsAny: [location]);

  //     if (lastDocument != null) {
  //       specializationQuery =
  //           specializationQuery.startAfterDocument(lastDocument);
  //       locationQuery = locationQuery.startAfterDocument(lastDocument);
  //     }

  //     // Execute the queries
  //     QuerySnapshot<Map<String, dynamic>> specializationSnapshot =
  //         await specializationQuery.get();
  //     QuerySnapshot<Map<String, dynamic>> locationSnapshot =
  //         await locationQuery.get();

  //     querySnapshots.add(specializationSnapshot);
  //     querySnapshots.add(locationSnapshot);
  //   } else if (location != null && location.isNotEmpty) {
  //     query = query.where('locations', arrayContainsAny: [location]);
  //   } else if (specialization != null && specialization.isNotEmpty) {
  //     query = query.where('specialization', arrayContains: specialization);
  //   }

  //   if (lastDocument != null) {
  //     query = query.startAfterDocument(lastDocument);
  //   }

  //   try {
  //     return await query.get();
  //   } catch (error) {
  //     // Handle error
  //     throw Exception('Error fetching doctors with pagination: $error');
  //   }
  // }

  Future<List<DoctorModel>> getFilteredDoctors(
      {String? location, String? specialization, String? condition}) async {
    try {
      if (location == null && specialization == null && condition == null) {
        // Fetch all doctors and order them by rating
        var querySnapshot = await _db
            .collection('doctors')
            .orderBy('rating', descending: true)
            .get();
        return querySnapshot.docs
            .map((doc) => DoctorModel.fromJson(doc.data()))
            .toList();
      }

      List<Future<List<DoctorModel>>> futures = [];

      // Query doctors by city
      if (location != null && location.isNotEmpty) {
        futures.add(_getDoctorsByLocation(location));
      }

      // Query doctors by specialization
      if (specialization != null && specialization.isNotEmpty) {
        futures.add(_getDoctorsBySpecialization(specialization));
      }

      // Query doctors by condition treated
      if (condition != null && condition.isNotEmpty) {
        futures.add(_getDoctorsByCondition(condition));
      }

      // Wait for all queries to complete
      List<List<DoctorModel>> results = await Future.wait(futures);

      // Combine results from all queries
      List<DoctorModel> combinedResults = [];
      for (List<DoctorModel> result in results) {
        combinedResults.addAll(result);
      }

      if (location != null && location.isNotEmpty) {
        combinedResults = combinedResults
            .where((doctor) => doctor.locations.contains(location))
            .toList();
      }

      if (specialization != null && specialization.isNotEmpty) {
        combinedResults = combinedResults
            .where((doctor) => doctor.specialization.contains(specialization))
            .toList();
      }

      if (condition != null && condition.isNotEmpty) {
        combinedResults = combinedResults
            .where((doctor) => doctor.conditionsTreated.contains(condition))
            .toList();
      }

      // Remove duplicates (if any)
      combinedResults = combinedResults.fold<List<DoctorModel>>(
        [],
        (List<DoctorModel> previous, DoctorModel current) {
          // Check if the userId already exists in the previous list
          // If not, add the current item to the list
          if (!previous.any((doctor) => doctor.userId == current.userId)) {
            previous.add(current);
          }
          return previous;
        },
      );

      return combinedResults;
    } catch (error) {
      // Handle error
      throw Exception('Error fetching filtered doctors: $error');
    }
  }

  Future<List<DoctorModel>> _getDoctorsByLocation(String city) async {
    var querySnapshot = await _db
        .collection('doctors')
        .where('locations', arrayContains: city)
        .get();
    return querySnapshot.docs
        .map((doc) => DoctorModel.fromJson(doc.data()))
        .toList();
  }

  Future<List<DoctorModel>> _getDoctorsBySpecialization(
      String specialization) async {
    var querySnapshot = await _db
        .collection('doctors')
        .where('specialization', arrayContains: specialization)
        .get();
    return querySnapshot.docs
        .map((doc) => DoctorModel.fromJson(doc.data()))
        .toList();
  }

  Future<List<DoctorModel>> _getDoctorsByCondition(String condition) async {
    var querySnapshot = await _db
        .collection('doctors')
        .where('conditionsTreated', arrayContains: condition)
        .get();
    return querySnapshot.docs
        .map((doc) => DoctorModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> createAppointment(
      {required DoctorModel doctorModel,
      required HealthProviderModel healthProviderModel,
      required String selectedSlot,
      required DateTime appointmentDate,
      required String patientName,
      required int patientAge,
      required String phoneNumber}) async {
    if (AuthService().getUser == null) return;
    var user = AuthService().getUser as User;
    String weekDay = Util().getWeekDayName(appointmentDate.weekday);

    // appointmentDate
    try {
      await _db.collection('appointments').add({
        'patient_id': user.uid,
        'patient_name': patientName,
        'patient_age': patientAge,
        'patient_phone_no': phoneNumber,
        'acc_display_name': user.displayName,
        'doctor_id': doctorModel.userId,
        'doctor_display_name': doctorModel.displayName,
        'doctor_name': doctorModel.fullName,
        'doctor_avatar': doctorModel.photoURL,
        'health_provider_id': healthProviderModel.id,
        'health_provider_location': healthProviderModel.location,
        'health_provider_name': healthProviderModel.name,
        'health_provider_avatar': healthProviderModel.avatar,
        'slot': selectedSlot,
        'week_day': weekDay,
        'created_at': FieldValue.serverTimestamp(),
        'status': 'pending',
        'appointment_date': appointmentDate,
      });

      // Create or update notification message document
      String messageDocId = '${user.uid}-${doctorModel.userId}';
      await _db.collection('messages').doc(messageDocId).set({
        'patient_name': user.displayName,
        'patient_id': user.uid,
        'patient_avatar': user.photoURL,
        'doctor_avatar': doctorModel.photoURL,
        'doctor_display_name': doctorModel.fullName,
        'timestamp': FieldValue.serverTimestamp(),
        'doctor_id': doctorModel.userId,
        'uid': messageDocId
      }, SetOptions(merge: true));

      // Create a sub-collection for conversations
      await _db
          .collection('messages')
          .doc(messageDocId)
          .collection('conversations')
          .add({
        'message': 'created Appointment for $patientName',
        'sender_id': user.uid,
        'sender_name': user.displayName,
        'type': 'activity',
        'timestamp': FieldValue.serverTimestamp(),
        'sender': 'patient'
      });

      print('Appointment created successfully');
    } catch (e) {
      print('Failed to create appointment: $e');
      throw Exception('Failed to create appointment');
    }
  }

  Stream<List<AppointmentModel>> streamAppointmentsByHealthProviderId(
      String healthProviderId) {
    return _db
        .collection('appointments')
        .where('health_provider_id', isEqualTo: healthProviderId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppointmentModel.fromJson(doc.data()))
            .toList());
  }

  Stream<List<MedicationDoc>> streamMedicationsByUserId() {
    var user = AuthService().getUser as User?;
    return _db
        .collection('medications')
        .where('subscribers', arrayContains: user != null ? user.uid : '')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MedicationDoc.fromJson(doc.data()))
            .toList());
  }

  Future<DoctorModel> getDoctorById(String doctorId) async {
    try {
      DocumentSnapshot doc =
          await _db.collection('doctors').doc(doctorId).get();
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        throw Exception("Doctor not found");
      }
      return DoctorModel.fromJson(data);
    } catch (e) {
      print("Error getting doctor: $e");
      throw e;
    }
  }

  Stream<List<MessageDoc>> streamChatById(String chatId) {
    return FirebaseFirestore.instance
        .collection('messages')
        .doc(chatId)
        .collection('conversations')
        .orderBy('timestamp') // assuming timestamp is used to order messages
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return MessageDoc.fromJson(doc.data());
            }).toList());
  }

  Future<ChatMessageDoc?> getChat(String chatId) async {
    DocumentSnapshot<Map<String, dynamic>> messageDocSnapshot =
        await FirebaseFirestore.instance
            .collection('messages')
            .doc(chatId)
            .get();

    if (messageDocSnapshot.exists) {
      return ChatMessageDoc.fromJson(messageDocSnapshot.data()!);
    } else {
      return null;
    }
  }

  void sendMessage(String chatId, String message) {
    // Get the current logged-in user
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      FirebaseFirestore.instance
          .collection('messages')
          .doc(chatId)
          .collection('conversations')
          .add({
        'message': message,
        'sender_id': user.uid,
        'sender_name': user.displayName ??
            'Anonymous', // Using displayName or fallback to 'Anonymous'
        'timestamp': Timestamp.now(),
        'type': 'conversation', // Assuming it's a regular message for now
        'sender':
            'patient', // Assuming the sender is always the patient for now
      }).then((_) {
        print('Message sent successfully!');
      }).catchError((error) {
        print('Error sending message: $error');
      });
    } else {
      print('Error: User is not logged in');
    }
  }
}
