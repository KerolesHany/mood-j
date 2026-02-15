import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DayMood extends StatelessWidget {
  const DayMood({required this.day, required this.emoji, super.key});
  final String day;
  final Emoji emoji;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(day, style: textTheme.titleSmall!),
        Container(
          padding: EdgeInsets.all(3.r),

          child: Text(
            emoji.toString(),
            style: textTheme.titleMedium!.copyWith(fontSize: 23.sp),
          ),
        ),
      ],
    );
  }
}
