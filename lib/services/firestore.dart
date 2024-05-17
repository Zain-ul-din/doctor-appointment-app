import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_app/services/models.dart';

class FireStoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<DoctorModel>> getTopTenDoctors() async {
    try {
      var ref = _db
          .collection('doctors')
          .orderBy('createdAt', descending: true)
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
}
