import 'package:flutter/material.dart';
import 'package:med_app/constants.dart';
import 'package:med_app/services/firestore.dart';
import 'package:med_app/services/models.dart';
import 'package:med_app/shared/DoctorsFilter.dart';
import 'package:search_choices/search_choices.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({Key? key}) : super(key: key);

  @override
  _DoctorsScreenState createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final FireStoreService _fireStoreService = FireStoreService();
  List<DoctorModel> _doctors = [];
  bool _isLoading = false;

  // Filter criteria
  final ValueNotifier<String?> _selectedCityNotifier =
      ValueNotifier<String?>(null);
  final ValueNotifier<String?> _selectedSpecializationNotifier =
      ValueNotifier<String?>(null);
  final ValueNotifier<String?> _selectedConditionNotifier =
      ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();
    _selectedCityNotifier.value = null;
    _selectedSpecializationNotifier.value = null;
    _selectedConditionNotifier.value = null;

    _extractArguments().then((_) {
      _refreshDoctors();
    });
  }

  Future<void> _extractArguments() async {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is DoctorsFilter) {
        setState(() {
          _selectedCityNotifier.value = args.location;
          _selectedSpecializationNotifier.value = args.specialization;
          _selectedConditionNotifier.value = args.condition;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Center(child: Text("Doctors")),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _doctors.isEmpty
                      ? const Center(child: Text('No doctors found'))
                      : ListView.builder(
                          itemCount: _doctors.length,
                          itemBuilder: (context, index) {
                            return doctorCard(
                                model: _doctors[index],
                                onTap: () {
                                  Navigator.pushNamed(context, '/doctor',
                                      arguments: _doctors[index]);
                                });
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            child:
                _buildFilterOptions(width: MediaQuery.of(context).size.width),
          ),
        );
      },
    );
  }

  Widget _buildFilterOptions({required double width}) {
    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: width,
            child: SearchChoices.single(
              items: cities.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              isExpanded: true,
              value: _selectedCityNotifier.value,
              hint: 'Select City',
              onChanged: (newValue) {
                _selectedCityNotifier.value = newValue;
              },
            ),
          ),
          Container(
            width: double.infinity,
            child: SearchChoices.single(
              items: specializations.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              isExpanded: true,
              value: _selectedSpecializationNotifier.value,
              hint: 'Select Specialization',
              onChanged: (newValue) {
                _selectedSpecializationNotifier.value = newValue;
              },
            ),
          ),
          Container(
            width: double.infinity,
            child: SearchChoices.single(
              items: conditions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              isExpanded: true,
              value: _selectedConditionNotifier.value,
              hint: 'Select Condition',
              onChanged: (newValue) {
                _selectedConditionNotifier.value = newValue;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _refreshDoctors();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigoAccent.shade100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search,
                    color: Colors.white,
                    weight: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Search',
                    style: kCardTitleStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _refreshDoctors() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _doctors = await _fireStoreService.getFilteredDoctors(
        location: _selectedCityNotifier.value,
        specialization: _selectedSpecializationNotifier.value,
        condition: _selectedConditionNotifier.value,
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching doctors: $error')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget doctorCard({required DoctorModel model, required Function onTap}) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 0.5), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(12), // Adjust the radius as needed
                  image: DecorationImage(
                    image: NetworkImage(model.photoURL),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.fullName,
                      style: kTitle1Style,
                    ),
                    Text(
                      "${model.primarySpecialization}, ${model.secondarySpecializations}",
                      style: kSubtitleStyle,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow.shade700,
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          "4.5",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ), // Added space between location and button
                    Row(
                      children: [
                        const Spacer(),
                        InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(
                                    color: Colors.indigoAccent.shade100),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                                horizontal: 6.0,
                              ),
                              child: Text(
                                "Book Appointment",
                                style: TextStyle(
                                  color: Colors.indigoAccent.shade100,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
