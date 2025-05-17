import 'package:flutter/material.dart';
import 'package:kidscare/core/helper/my_responsive.dart';
import 'package:kidscare/core/widget/custom_elvated_btn.dart';
import 'package:kidscare/core/utils/app_colors.dart';

class BounusTimeView extends StatefulWidget {
  const BounusTimeView({super.key}) : onDone = null;

  static Future<int?> showBounusTime(BuildContext context) async {
    int? result;
    await showModalBottomSheet(
      context: context,
      builder: (context) => BounusTimeView._withResult((minutes) {
        result = minutes;
        Navigator.pop(context);
      }),
    );
    return result;
  }

  // Private constructor for callback
  const BounusTimeView._withResult(this.onDone, {Key? key}) : super(key: key);

  final void Function(int minutes)? onDone;

  @override
  State<BounusTimeView> createState() => _BounusTimeViewState();
}

class _BounusTimeViewState extends State<BounusTimeView> {
  int minutes = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: const BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Give bouns',
            style: TextStyle(
              color: AppColors.yellow,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const Divider(thickness: 0.2, color: Colors.white24),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.white, size: 40),
                onPressed: () {
                  setState(() {
                    if (minutes > 1) minutes -= 1;
                  });
                },
              ),
              const SizedBox(width: 24),
              Text(
                '$minutes min',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 24),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white, size: 40),
                onPressed: () {
                  setState(() {
                    minutes += 1;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 36),
          SizedBox(
            width: 300,
            height: 48,
            child: CustomElevatedButton(
              textButton: 'Done',
              onPressed: () {
                if (widget.onDone != null) {
                  widget.onDone!(minutes);
                } else {
                  Navigator.pop(context, minutes);
                }
              },
              backgroundColor: const Color(0xFFFFF6DC),
              foregroundColor: AppColors.yellow,
              shadowColor: const Color(0xFFFFF6DC),
            ),
          ),
        ],
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
        borderRadius: BorderRadius.circular(
          MyResponsive.width(context, value: 10.0),
        ),
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
