import 'package:flutter/material.dart';
import 'package:kidscare/core/utils/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';  // Add the Bloc package
import '../../../core/helper/my_responsive.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/widget/custom_elvated_btn.dart';
import '../../../core/widget/custom_svg.dart';
import 'package:kidscare/features/home/widgets/custom_action_btn.dart';
import '../manager/cubit/time_cubit/time_cubit.dart';
import 'package:intl/intl.dart';  // Correct import here

class SetTimeView extends StatelessWidget {
  const SetTimeView({super.key});

  String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt); // Example: 09:00 AM
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimeCubit(),
      child: CustomActionBottom(
        icon: CustomSvg(assetPath: AppAssets.time),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: AppColors.blue,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            builder: (context) {
              return SizedBox(
                height: MyResponsive.height(context, value: 320),
                child: BlocBuilder<TimeCubit, Map<String, TimeOfDay>>(
                  builder: (context, timeState) {
                    final startTime = timeState['startTime']!;
                    final endTime = timeState['endTime']!;
                    return Padding(
                      padding: EdgeInsets.all(MyResponsive.width(context, value: 16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center, // Centering horizontally
                        children: [
                          Text(
                            'Set Time',
                            style: TextStyle(
                              fontSize: MyResponsive.width(context, value: 25),
                              color: AppColors.yellowLight,
                            ),
                          ),
                          const Divider(thickness: 0.2),
                          SizedBox(height: MyResponsive.height(context, value: 20)),
                          TimeRangeDisplay(
                            start: formatTime(startTime),
                            end: formatTime(endTime),
                            onStartTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: startTime,
                              );
                              if (picked != null) {
                                context.read<TimeCubit>().updateStartTime(picked);
                              }
                            },
                            onEndTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: endTime,
                              );
                              if (picked != null) {
                                context.read<TimeCubit>().updateEndTime(picked);
                              }
                            },
                          ),
                          SizedBox(height: MyResponsive.height(context, value: 16)),
                          CustomElevatedButton(
                            textButton: 'Done',
                            shadowColor: AppColors.yellowLight,
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Child usage time saved successfully',style: TextStyle(color: AppColors.blue),),
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
              );
            },
          );
        },
      ),
    );
  }
}

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
      color: AppColors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the row content
        children: <Widget>[
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
          GestureDetector(onTap: onEndTap, child: _TimeBox(time: end)),
        ],
      ),
    );
  }
}

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
        border: Border.all(color: AppColors.yellow, width: 1),
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
