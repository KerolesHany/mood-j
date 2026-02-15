import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JournalDetailImage extends StatelessWidget {
  final String? imgPath;
  final bool isLoaded;

  const JournalDetailImage({
    super.key,
    required this.imgPath,
    required this.isLoaded,
  });

  @override
  Widget build(BuildContext context) {
    bool isExist = imgPath != null && File(imgPath!).existsSync();

    if (!isExist) return const SizedBox();
    if (!isLoaded) return const Center(child: CircularProgressIndicator());

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Image.file(File(imgPath!), fit: BoxFit.cover),
    );
  }
}
