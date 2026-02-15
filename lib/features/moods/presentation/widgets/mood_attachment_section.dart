import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moodly_j/core/theme/app_theme.dart';
import 'package:moodly_j/features/moods/presentation/widgets/pro_item.dart';
import 'package:moodly_j/l10n/app_localizations.dart';

class MoodAttachmentSection extends StatelessWidget {
  final XFile? selectedImg;
  final File? recorededFile;
  final VoidCallback onPickImage;
  final VoidCallback onRecordVoice;
  final VoidCallback onShowRecordedVoice;

  const MoodAttachmentSection({
    super.key,
    required this.selectedImg,
    required this.recorededFile,
    required this.onPickImage,
    required this.onRecordVoice,
    required this.onShowRecordedVoice,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        GestureDetector(
          onTap: onPickImage,
          child: ProItem(
            done: selectedImg != null,
            icon: Icons.add_photo_alternate,
            title: "Add Photo",
          ),
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: onRecordVoice,
          child: ProItem(
            done: recorededFile != null,
            icon: Icons.mic,
            title: localization.recordVoice,
          ),
        ),
        if (recorededFile != null)
          Row(
            children: [
              TextButton(
                onPressed: onShowRecordedVoice,
                child: Text(
                  localization.listenYourRecords,
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color: AppTheme.forestGreen,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
