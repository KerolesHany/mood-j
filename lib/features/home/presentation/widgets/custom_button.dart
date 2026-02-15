import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.icon,
    required this.title,
    required this.color,
    required this.bgColor,

    super.key,
    required this.onPressed,
  });
  final Function()? onPressed;
  final Color bgColor;
  final Color color;

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 16.r),
        backgroundColor: bgColor,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Icon(icon, size: 28.r, color: color),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(fontSize: 22.sp, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
