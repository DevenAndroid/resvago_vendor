import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago_vendor/widget/appassets.dart';

import '../widget/apptheme.dart';
import '../widget/common_text_field.dart';
import '../widget/custom_textfield.dart';

class AddBookingSlot extends StatefulWidget {
  const AddBookingSlot({super.key});

  @override
  State<AddBookingSlot> createState() => _AddBookingSlotState();
}

class _AddBookingSlotState extends State<AddBookingSlot> {
  final _formKeyBooking = GlobalKey<FormState>();
  TextEditingController selectDateController = TextEditingController();
  TextEditingController lunchStartTimeController = TextEditingController();
  TextEditingController lunchEndTimeController = TextEditingController();
  TextEditingController intervalTimeController = TextEditingController();
  TextEditingController dinnerStartTimeController = TextEditingController();
  TextEditingController dinnerEndTimeController = TextEditingController();
  TextEditingController intervalTimePasswordController1 =
      TextEditingController();
  TextEditingController numberOfGuestController = TextEditingController();
  TextEditingController setOffersController = TextEditingController();
  TimeOfDay? selectedTime;
  String? _hour;
  String? _minute;
  String? _time;
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime!,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerTheme.of(context).copyWith(
              hourMinuteTextColor:Colors.black,
              hourMinuteColor:  AppTheme.primaryColor,
              dayPeriodTextColor: Colors.black,
              dialHandColor: Colors.black,
              dialBackgroundColor: AppTheme.primaryColor,
              entryModeIconColor: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime!.hour.toString();
        _minute = selectedTime!.minute.toString();
        _time = '$_hour : $_minute';
        lunchStartTimeController.text = _time!;
        lunchStartTimeController.text = DateFormat('hh:mm a').format(DateTime(
          2019,
          8,
          1,
          selectedTime!.hour,
          selectedTime!.minute,
        ));
      });
    }
  }

  TimeOfDay? selectedLunchEndTime;
  String? _hourLunchEnd;
  String? _minuteLunchEnd;
  String? _timeLunchEnd;
  Future<void> selectTimeLunchEnd(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedLunchEndTime!,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerTheme.of(context).copyWith(
              hourMinuteTextColor:Colors.black,
              hourMinuteColor:  AppTheme.primaryColor,
              dayPeriodTextColor: Colors.black,
              dialHandColor: Colors.black,
              dialBackgroundColor: AppTheme.primaryColor,
              entryModeIconColor: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedLunchEndTime = picked;
       _hourLunchEnd = selectedTime!.hour.toString();
       _minuteLunchEnd = selectedTime!.minute.toString();
       _timeLunchEnd = '$_hourLunchEnd : $_minuteLunchEnd';
        lunchEndTimeController.text = _timeLunchEnd!;
        lunchEndTimeController.text = DateFormat('hh:mm a').format(DateTime(
          2019,
          8,
          1,
          selectedLunchEndTime!.hour,
          selectedLunchEndTime!.minute,
        ));
      });
    }
  }

  TimeOfDay? selectedTimeInterval;
  String? _hourInterval;
  String? _minuteInterval;
  String? _timeInterval;
  Future<void> selectTimeInterval(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTimeInterval!,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerTheme.of(context).copyWith(
              hourMinuteTextColor:Colors.black,
              hourMinuteColor:  AppTheme.primaryColor,
              dayPeriodTextColor: Colors.black,
              dialHandColor: Colors.black,
              dialBackgroundColor: AppTheme.primaryColor,
              entryModeIconColor: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTimeInterval = picked;
       _hourInterval = selectedTime!.hour.toString();
       _minuteInterval = selectedTime!.minute.toString();
       _timeInterval = '$_hourInterval : $_minuteInterval';
        intervalTimeController.text = _timeInterval!;
        intervalTimeController.text = DateFormat('hh:mm a').format(DateTime(
          2019,
          8,
          1,
          selectedTimeInterval!.hour,
          selectedTimeInterval!.minute,
        ));
      });
    }
  }

  TimeOfDay? selectedTimeDinnerStart;
  String? _hourDinnerStart;
  String? _minuteDinnerStart;
  String? _timeDinnerStart;
  Future<void> selectTimeDinnerStart(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTimeDinnerStart!,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerTheme.of(context).copyWith(
              hourMinuteTextColor:Colors.black,
              hourMinuteColor:  AppTheme.primaryColor,
              dayPeriodTextColor: Colors.black,
              dialHandColor: Colors.black,
              dialBackgroundColor: AppTheme.primaryColor,
              entryModeIconColor: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTimeDinnerStart = picked;
       _hourDinnerStart = selectedTime!.hour.toString();
       _minuteDinnerStart = selectedTime!.minute.toString();
       _timeDinnerStart = '$_hourDinnerStart : $_minuteDinnerStart';
        dinnerStartTimeController.text = _timeDinnerStart!;
        dinnerStartTimeController.text = DateFormat('hh:mm a').format(DateTime(
          2019,
          8,
          1,
          selectedTimeDinnerStart!.hour,
          selectedTimeDinnerStart!.minute,
        ));
      });
    }
  }

  TimeOfDay? selectedTimeDinnerEnd;
  String? _hourDinnerEnd;
  String? _minutDinnerEnd;
  String? _timeDinnerEnd;
  Future<void> selectTimeDinnerEnd(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTimeDinnerEnd!,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerTheme.of(context).copyWith(
              hourMinuteTextColor:Colors.black,
              hourMinuteColor:  AppTheme.primaryColor,
              dayPeriodTextColor: Colors.black,
              dialHandColor: Colors.black,
              dialBackgroundColor: AppTheme.primaryColor,
              entryModeIconColor: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTimeDinnerEnd = picked;
        _hourDinnerEnd = selectedTime!.hour.toString();
        _minutDinnerEnd = selectedTime!.minute.toString();
        _timeDinnerEnd = '$_hourDinnerEnd : $_minutDinnerEnd';
        dinnerEndTimeController.text = _timeDinnerEnd!;
        dinnerEndTimeController.text = DateFormat('hh:mm a').format(DateTime(
          2019,
          8,
          1,
          selectedTimeDinnerEnd!.hour,
          selectedTimeDinnerEnd!.minute,
        ));
      });
    }
  }

  TimeOfDay? selectedTimeDinnerInterval;
  String? _hourDinnerInterval;
  String? _minuteDinnerInterval;
  String? _timeDinnerInterval;
  Future<void> selectTimeDinnerInterval(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTimeDinnerInterval!,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerTheme.of(context).copyWith(
              hourMinuteTextColor:Colors.black,
              hourMinuteColor:  AppTheme.primaryColor,
              dayPeriodTextColor: Colors.black,
              dialHandColor: Colors.black,
              dialBackgroundColor: AppTheme.primaryColor,
              entryModeIconColor: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTimeDinnerInterval = picked;
        _hourDinnerInterval = selectedTimeDinnerInterval!.hour.toString();
        _minuteDinnerInterval = selectedTimeDinnerInterval!.minute.toString();
        _timeDinnerInterval = '$_hourDinnerInterval : $_minuteDinnerInterval';
        intervalTimePasswordController1.text = _timeDinnerInterval!;
        intervalTimePasswordController1.text = DateFormat('hh:mm a').format(DateTime(
          2019,
          8,
          1,
          selectedTimeDinnerInterval!.hour,
          selectedTimeDinnerInterval!.minute,
        ));
      });
    }
  }
  @override
  void initState() {
    super.initState();
    selectedTimeDinnerInterval = TimeOfDay.now();
    selectedTimeDinnerEnd = TimeOfDay.now();
    selectedTimeInterval = TimeOfDay.now();
    selectedLunchEndTime = TimeOfDay.now();
    selectedTime = TimeOfDay.now();
    selectedTimeDinnerStart = TimeOfDay.now();

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        appBar: backAppBar(
            title: "Create Slot",
            context: context,
            backgroundColor: Colors.white),
        body: SingleChildScrollView(
            child: Form(
                key: _formKeyBooking,
                child: Column(children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                          padding: const EdgeInsets.all(15),
                          width: size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Select Date",
                                  style: GoogleFonts.poppins(
                                      color: AppTheme.registortext,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RegisterTextFieldWidget(
                                  readOnly: true,
                                  onTap: () async {

                                      DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1950),
                                          //DateTime.now() - not to allow to choose before today.
                                          lastDate: DateTime(2100));

                                      if (pickedDate != null) {
                                        print(
                                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                        String formattedDate =
                                        DateFormat('yyyy-MM-dd').format(pickedDate);
                                        print(
                                            formattedDate); //formatted date output using intl package =>  2021-03-16
                                        setState(() {
                                          selectDateController.text =
                                              formattedDate; //set output date to TextField value.
                                        });
                                      } else {}

                                  },
                                  controller: selectDateController,
                                  // length: 10,
                                  validator: RequiredValidator(
                                      errorText: 'Please enter your Date '),
                                  suffix: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SvgPicture.asset(
                                      AppAssets.calender,
                                    ),
                                  ),
                                  hint: '10 Oct 2023',
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Lunch Start Time",
                                  style: GoogleFonts.poppins(
                                      color: AppTheme.registortext,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RegisterTextFieldWidget(
                                  readOnly: true,
                                  onTap: () async {
                                    selectTime(context);
                                    },

                                  controller: lunchStartTimeController,
                                  // length: 10,
                                  validator: RequiredValidator(
                                      errorText:
                                          'Please enter your Lunch Start Time '),
                                  suffix: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SvgPicture.asset(AppAssets.clock),
                                  ),
                                  hint: '10:30AM',
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Lunch End Time",
                                  style: GoogleFonts.poppins(
                                      color: AppTheme.registortext,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RegisterTextFieldWidget(
                                  readOnly: true,
                                  onTap: () async {
                                    selectTimeLunchEnd(context);
                                  },
                                  controller: lunchEndTimeController,
                                  suffix: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SvgPicture.asset(AppAssets.clock),
                                  ),
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText:
                                            'Please enter Lunch End Time'),
                                  ]),
                                  hint: '10:30AM',
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Interwall Time",
                                  style: GoogleFonts.poppins(
                                      color: AppTheme.registortext,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RegisterTextFieldWidget(
                                  readOnly: true,
                                  onTap: () async {
                                    selectTimeInterval(context);
                                  },
                                  controller: intervalTimeController,
                                  suffix: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SvgPicture.asset(AppAssets.clock),
                                  ),
                                  validator: RequiredValidator(
                                      errorText:
                                          'Please enter your Interwall Time '),
                                  hint: '30 Mint',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ]))),
                  SizedBox(height: 20,),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                          padding: const EdgeInsets.all(15),
                          width: size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Dinner Start Time",
                                  style: GoogleFonts.poppins(
                                      color: AppTheme.registortext,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RegisterTextFieldWidget(
                                  readOnly: true,
                                  onTap: () async {
                                    selectTimeDinnerStart(context);
                                  },
                                  controller: dinnerStartTimeController,
                                  // length: 10,
                                  validator: RequiredValidator(
                                      errorText: 'Please enter your Dinner Start Time '),
                                  suffix: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SvgPicture.asset(
                                      AppAssets.clock,
                                    ),
                                  ),
                                  hint: '8:30AM',
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Dinner End Time",
                                  style: GoogleFonts.poppins(
                                      color: AppTheme.registortext,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RegisterTextFieldWidget(
                                  readOnly: true,
                                  onTap: () async {
                                    selectTimeDinnerEnd(context);
                                  },
                                  controller: dinnerEndTimeController,
                                  // length: 10,
                                  validator: RequiredValidator(
                                      errorText:
                                          'Please enter your Dinner End Time '),
                                  suffix: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SvgPicture.asset(AppAssets.clock),
                                  ),
                                  hint: '10:30AM',
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Interval Time",
                                  style: GoogleFonts.poppins(
                                      color: AppTheme.registortext,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RegisterTextFieldWidget(
                                  readOnly: true,
                                  onTap: () async {
                                    selectTimeDinnerInterval(context);
                                  },
                                  controller: intervalTimePasswordController1,
                                  suffix: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SvgPicture.asset(AppAssets.clock),
                                  ),
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText:
                                            'Please enter Interval Time'),
                                  ]),
                                  hint: '10:30AM',
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Number of guest",
                                  style: GoogleFonts.poppins(
                                      color: AppTheme.registortext,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RegisterTextFieldWidget(
                                  controller: numberOfGuestController,
                                  suffix: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                  ),
                                  validator: RequiredValidator(
                                      errorText:
                                          'Please enter your no of guest '),
                                  hint: '30 Mint',
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Set Offers",
                                  style: GoogleFonts.poppins(
                                      color: AppTheme.registortext,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RegisterTextFieldWidget(
                                  controller: setOffersController,
                                  suffix: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                  ),
                                  validator: RequiredValidator(
                                      errorText:
                                      'Please enter your offer '),
                                  hint: '30 Mint',
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                CommonButtonBlue(
                                  onPressed: () {
                                    if (_formKeyBooking.currentState!.validate()) {
                                      // Get.back();
                                      // }
                                    }},
                                  title: 'Create Slot',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ]))),
                  SizedBox(height: 100,),
                ]))));
  }
}
