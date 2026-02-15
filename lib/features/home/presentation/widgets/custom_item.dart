import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomItem extends StatelessWidget {
  const CustomItem({
    this.emoji,
    super.key,
    required this.title,
    required this.bgColor,
    required this.color,
    required this.result,
    this.icon,
    this.fixedIcon = true,
  });
  final String title;
  final Color bgColor;
  final Color color;
  final String result;
  final String? icon;
  final Emoji? emoji;
  final bool fixedIcon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.all(6.r),
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(
              255,
              208,
              192,
              192,
            ), // زودنا الشفافية شوية
            blurRadius: 12, // خفف النعومة
            spreadRadius: 1, // نشر بسيط للظل
            offset: const Offset(0, 4), // تحت شوية
          ),
        ],
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(title, style: textTheme.titleSmall!.copyWith(color: color)),
          SizedBox(height: 12.h),
          fixedIcon
              ? Image.asset(icon ?? "", width: 40.w, fit: BoxFit.fill)
              : Text(emoji.toString(), style: textTheme.titleLarge),
          // Container(child: emoji,)
          SizedBox(height: 12.h),
          Text(
            result,
            style: textTheme.titleLarge!.copyWith(
              fontSize: 25.sp,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
