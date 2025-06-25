import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// Assuming these are your core utility files and widgets
import 'package:kidscare/core/utils/app_colors.dart';
import '../../../core/helper/my_responsive.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/widget/custom_elvated_btn.dart';
import '../../../core/widget/custom_svg.dart';
import 'package:kidscare/features/home/widgets/custom_action_btn.dart';

// Your Cubit
import '../manager/cubit/time_cubit/time_cubit.dart'; // Make sure this path is correct

class SetTimeView extends StatelessWidget {
  const SetTimeView({super.key});

  // Helper function to format TimeOfDay into a readable string
  String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    // Create a DateTime object with today's date and the given time
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    // Format the DateTime object to 'hh:mm a' (e.g., 09:00 AM)
    return DateFormat('hh:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    // The BlocProvider should *not* be here for the modal bottom sheet scenario,
    // as the modal sheet creates a new context branch.
    return CustomActionBottom(
      icon: CustomSvg(assetPath: AppAssets.time),
      onPressed: () {
        // Show the modal bottom sheet when the button is pressed
        showModalBottomSheet(
          context: context,
          isScrollControlled: true, // Allows the sheet to take full screen height if needed
          backgroundColor: AppColors.blue, // Custom background color
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)), // Rounded top corners
          ),
          builder: (modalContext) { // Use modalContext to distinguish from the parent context
            return BlocProvider(
              create: (_) => TimeCubit(), // Create a new instance of TimeCubit for the modal
              child: SizedBox(
                height: MyResponsive.height(modalContext, value: 320), // Set fixed height for the sheet
                child: BlocBuilder<TimeCubit, Map<String, TimeOfDay>>(
                  builder: (blocBuilderContext, timeState) { // Use blocBuilderContext for inner widgets
                    final startTime = timeState['startTime']!; // Get start time from cubit state
                    final endTime = timeState['endTime']!;     // Get end time from cubit state
                    return Padding(
                      padding: EdgeInsets.all(MyResponsive.width(modalContext, value: 16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center, // Center contents horizontally
                        children: [
                          Text(
                            'Set Time',
                            style: TextStyle(
                              fontSize: MyResponsive.width(modalContext, value: 25),
                              color: AppColors.yellowLight,
                            ),
                          ),
                          const Divider(thickness: 0.2), // A thin divider
                          SizedBox(height: MyResponsive.height(modalContext, value: 20)),
                          TimeRangeDisplay(
                            start: formatTime(startTime), // Display formatted start time
                            end: formatTime(endTime),     // Display formatted end time
                            onStartTap: () async {
                              // Show time picker for start time
                              final picked = await showTimePicker(
                                context: blocBuilderContext, // Use context where cubit is accessible
                                initialTime: startTime,
                              );
                              if (picked != null) {
                                // Update start time in cubit if a time is picked
                                blocBuilderContext.read<TimeCubit>().updateStartTime(picked);
                              }
                            },
                            onEndTap: () async {
                              // Show time picker for end time
                              final picked = await showTimePicker(
                                context: blocBuilderContext, // Use context where cubit is accessible
                                initialTime: endTime,
                              );
                              if (picked != null) {
                                // Update end time in cubit if a time is picked
                                blocBuilderContext.read<TimeCubit>().updateEndTime(picked);
                              }
                            },
                          ),
                          SizedBox(height: MyResponsive.height(modalContext, value: 16)),
                          CustomElevatedButton(
                            textButton: 'Done',
                            shadowColor: AppColors.yellowLight,
                            onPressed: () {
                              Navigator.pop(modalContext); // Close the bottom sheet
                              // Show a success message using a SnackBar
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Child usage time saved successfully',
                                    style: TextStyle(color: AppColors.blue),
                                  ),
                                  backgroundColor: AppColors.yellow,
                                ),
                              );
                            },
                            backgroundColor: AppColors.yellowLight,
                            foregroundColor: AppColors.blue,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Widget to display the time range and handle taps to open time pickers
class TimeRangeDisplay extends StatelessWidget {
  final String start;
  final String end;
  final VoidCallback onStartTap;
  final VoidCallback onEndTap;

  const TimeRangeDisplay({
    super.key,
    required this.start,
    required this.end,
    required this.onStartTap,
    required this.onEndTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MyResponsive.width(context, value: 15.0)),
      color: AppColors.blue, // Background color for the time range container
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the time boxes horizontally
        children: <Widget>[
          // GestureDetector for the start time box
          GestureDetector(onTap: onStartTap, child: _TimeBox(time: start)),
          SizedBox(width: MyResponsive.width(context, value: 12.0)),
          Text(
            'to',
            style: TextStyle(
              color: Colors.white,
              fontSize: MyResponsive.width(context, value: 16.0),
            ),
          ),
          SizedBox(width: MyResponsive.width(context, value: 12.0)),
          // GestureDetector for the end time box
          GestureDetector(onTap: onEndTap, child: _TimeBox(time: end)),
        ],
      ),
    );
  }
}

// Private widget for a single time display box
class _TimeBox extends StatelessWidget {
  final String time;

  const _TimeBox({required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MyResponsive.width(context, value: 35.0),
        vertical: MyResponsive.height(context, value: 12.0),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MyResponsive.width(context, value: 10.0)),
        border: Border.all(color: AppColors.yellow, width: 1), // Yellow border
      ),
      child: Text(
        time,
        style: TextStyle(
          color: Colors.white,
          fontSize: MyResponsive.width(context, value: 17.0),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
