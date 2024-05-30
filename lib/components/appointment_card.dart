import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_app/services/models.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentCard({Key? key, required this.appointment})
      : super(key: key);

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointmentDate =
        DateFormat.yMMMd().format(appointment.appointmentDate.toDate());
    final appointmentTime = appointment.slot;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            appointment.doctorAvatar,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          appointment.doctorDisplayName,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${appointment.healthProviderName}, ${appointment.healthProviderLocation}',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 2.0),
            Text(
              'Patient Name: ${appointment.patientName}',
              style:
                  const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
            ),
            Text(
              'Timing: $appointmentDate, $appointmentTime',
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: _getStatusColor(appointment.status),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            appointment.status,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}
