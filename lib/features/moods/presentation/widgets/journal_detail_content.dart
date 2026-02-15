import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:moodly_j/core/get_emoji.dart';
import 'package:moodly_j/core/theme/app_theme.dart';
import 'package:moodly_j/features/moods/domain/entities/mood_entity.dart';
import 'package:moodly_j/features/moods/presentation/widgets/custom_audio_player.dart';
import 'package:moodly_j/features/moods/presentation/widgets/journal_detail_image.dart';

class JournalDetailContent extends StatelessWidget {
  final MoodEntity? mood;
  final bool isLoaded;

  const JournalDetailContent({
    super.key,
    required this.mood,
    required this.isLoaded,
  });

  @override
  Widget build(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    DateFormat dateFormat = DateFormat.yMMMMd(locale.toString());
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: const Color(0xffF4F4F9),
      ),
      child: Column(
        children: [
          Text(
            textAlign: TextAlign.center,
            getEmoji(mood!.emoji, context).$1.toString(),
            style: TextStyle(fontSize: 60.sp),
          ),
          Text(
            textAlign: TextAlign.center,
            dateFormat.format(mood?.moodDate ?? DateTime.now()),
            style: textTheme.titleMedium!.copyWith(
              color: AppTheme.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(height: 20.h),
          JournalDetailImage(
            imgPath: mood?.imgPath,
            isLoaded: isLoaded,
          ),
          SizedBox(height: 20.h),
          Text(
            mood?.description ?? "",
            style: textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          if (mood?.audioPath != null &&
              File(mood?.audioPath ?? "").existsSync())
            CustomAudioPlayer(recorededFile: File(mood?.audioPath ?? ""))
          else
            const SizedBox(),
        ],
      ),
    );
  }
}
