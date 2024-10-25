import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanny_fairy/res/components/rounded_button.dart';
import 'package:nanny_fairy/res/components/widgets/vertical_spacing.dart';
import 'package:nanny_fairy/utils/routes/routes_name.dart';
import 'package:nanny_fairy/utils/utils.dart';
import '../../../res/components/colors.dart';
import '../../../res/components/day_button.dart';

class AvailabilityView extends StatefulWidget {
  const AvailabilityView({super.key});

  @override
  State<AvailabilityView> createState() => _AvailabilityViewState();
}

class _AvailabilityViewState extends State<AvailabilityView> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  // String selectedDay = 'Monday';
  List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  Map<String, String> selectedTimes = {};
  void _storeTimeInDatabase() {
    final firebaseAuth = FirebaseAuth.instance;
    final userId = firebaseAuth.currentUser!.uid;

    // Create a map to hold the times for each period
    Map<String, String> times = {
      'MorningStart': selectedTimes['MorningStart'] ?? '',
      'MorningEnd': selectedTimes['MorningEnd'] ?? '',
      'AfternoonStart': selectedTimes['AfternoonStart'] ?? '',
      'AfternoonEnd': selectedTimes['AfternoonEnd'] ?? '',
      'EveningStart': selectedTimes['EveningStart'] ?? '',
      'EveningEnd': selectedTimes['EveningEnd'] ?? '',
    };

    // Store the map in Firebase under a user-specific path
    _dbRef.child('Providers').child(userId).child('Time').set(times);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: PreferredSize(
        preferredSize: const Size.square(70),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(
              Icons.west,
              color: AppColor.whiteColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Availability',
            style: GoogleFonts.getFont(
              "Poppins",
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: AppColor.whiteColor,
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: const Color(0xff1B81BC)
                          .withOpacity(0.10), // Stroke color with 10% opacity
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff1B81BC).withOpacity(
                            0.1), // Drop shadow color with 4% opacity
                        blurRadius: 2,
                        offset: const Offset(1, 2),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                            height: 16), // Added spacing from the top
                        Text(
                          'Availability',
                          style: GoogleFonts.getFont(
                            "Poppins",
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColor.blackColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Officia irure irure an',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.grayColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            DayButton(
                              day: 'M',
                              isSelected: false,
                              onTap: (bool isSelected) {},
                            ),
                            const SizedBox(width: 8),
                            DayButton(
                              day: 'T',
                              isSelected: false,
                              onTap: (bool isSelected) {},
                            ),
                            const SizedBox(width: 8),
                            DayButton(
                              day: 'W',
                              isSelected: false,
                              onTap: (bool isSelected) {},
                            ),
                            const SizedBox(width: 8),
                            DayButton(
                              day: 'T',
                              isSelected: false,
                              onTap: (bool isSelected) {},
                            ),
                            const SizedBox(width: 8),
                            DayButton(
                              day: 'F',
                              isSelected: false,
                              onTap: (bool isSelected) {},
                            ),
                            const SizedBox(width: 8),
                            DayButton(
                              day: 'S',
                              isSelected: false,
                              onTap: (bool isSelected) {},
                            ),
                            const SizedBox(width: 8),
                            DayButton(
                              day: 'S',
                              isSelected: false,
                              onTap: (bool isSelected) {},
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const AvailabilityRow(
                          label: 'Morning',
                          availability: [
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false
                          ],
                          timePeriod: 'morning',
                        ),
                        const Divider(),
                        const AvailabilityRow(
                          label: 'Evening',
                          availability: [
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false
                          ],
                          timePeriod: 'Evening',
                        ),
                        const Divider(),
                        const AvailabilityRow(
                          label: 'Afternoon',
                          availability: [
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false
                          ],
                          timePeriod: 'Afternoon',
                        ),
                        const VerticalSpeacing(10),
                      ],
                    ),
                  ),
                ),
                const VerticalSpeacing(20.0),
                Container(
                  height: 216,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: const Color(0xff1B81BC)
                          .withOpacity(0.10), // Stroke color with 10% opacity
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff1B81BC).withOpacity(
                            0.1), // Drop shadow color with 4% opacity
                        blurRadius: 2,
                        offset: const Offset(1, 2),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select Time',
                              style: GoogleFonts.getFont(
                                "Poppins",
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.blackColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Morning   ',
                                  style: GoogleFonts.getFont(
                                    "Poppins",
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.blackColor,
                                    ),
                                  ),
                                ),
                                const Text('from'),
                                _timePicker('Morning', 'Start'),
                                const Text('to'),
                                _timePicker('Morning', 'End'),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Afternoon',
                                  style: GoogleFonts.getFont(
                                    "Poppins",
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.blackColor,
                                    ),
                                  ),
                                ),
                                const Text('from'),
                                _timePicker('Afternoon', 'Start'),
                                const Text('to'),
                                _timePicker('Afternoon', 'End'),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Evening   ',
                                  style: GoogleFonts.getFont(
                                    "Poppins",
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.blackColor,
                                    ),
                                  ),
                                ),
                                const Text('from'),
                                _timePicker('Evening', 'Start'),
                                const Text('to'),
                                _timePicker('Evening', 'End'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalSpeacing(46.0),
                RoundedButton(
                    title: 'Register',
                    onpress: () {
                      if (selectedTimes.isNotEmpty) {
                        Navigator.pushNamed(
                            context, RoutesName.educationHorlyView);
                      } else {
                        Utils.snackBar(
                            'Please select the day and time', context);
                      }
                    }),
                const VerticalSpeacing(40.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // time Picker
  Widget _timePicker(String period, String type) {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (selectedTime != null) {
          setState(() {
            selectedTimes['$period$type'] = selectedTime.format(context);
            _storeTimeInDatabase();
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColor.grayColor.withOpacity(0.5),
          ),
        ),
        child: Text(
          selectedTimes['$period$type'] ?? 'Select Time',
          style: const TextStyle(fontSize: 12, color: AppColor.blackColor),
        ),
      ),
    );
  }
}

class AvailabilityRow extends StatefulWidget {
  final String label;
  final List<bool> availability;
  final String timePeriod; // morning, evening, or afternoon

  const AvailabilityRow({
    super.key,
    required this.label,
    required this.availability,
    required this.timePeriod,
  });

  @override
  _AvailabilityRowState createState() => _AvailabilityRowState();
}

class _AvailabilityRowState extends State<AvailabilityRow> {
  late List<bool> _availability;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _availability =
        List.from(widget.availability); // Initialize with widget's availability
  }

  void _toggleAvailability(int index) {
    setState(() {
      _availability[index] = !_availability[index];
      _storeAvailabilityInDatabase(index);
    });
  }

  void _storeAvailabilityInDatabase(int index) {
    final firebaseAuth = FirebaseAuth.instance;
    final userId = firebaseAuth.currentUser!.uid;
    String day = _getDayName(index);
    _dbRef
        .child('Providers')
        .child(userId)
        .child('Availability')
        .child('${widget.timePeriod}/$day')
        .set(_availability[index]);
  }

  String _getDayName(int index) {
    switch (index) {
      case 0:
        return 'Monday';
      case 1:
        return 'Tuesday';
      case 2:
        return 'Wednesday';
      case 3:
        return 'Thursday';
      case 4:
        return 'Friday';
      case 5:
        return 'Saturday';
      case 6:
        return 'Sunday';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Row(
            children: _availability
                .asMap()
                .entries
                .map((entry) => GestureDetector(
                      onTap: () => _toggleAvailability(entry.key),
                      child: AvailabilityCheckBox(isAvailable: entry.value),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class AvailabilityCheckBox extends StatelessWidget {
  final bool isAvailable;

  const AvailabilityCheckBox({
    super.key,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isAvailable ? AppColor.primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColor.blackColor, width: 0.5),
      ),
      height: 23,
      width: 22,
      child: isAvailable
          ? const Icon(
              Icons.check,
              size: 16,
              color: Colors.white,
            )
          : null,
    );
  }
}
