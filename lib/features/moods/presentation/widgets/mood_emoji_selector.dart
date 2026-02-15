import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodly_j/core/theme/app_theme.dart';
import 'package:moodly_j/features/moods/presentation/widgets/custom_mood.dart';

class MoodEmojiSelector extends StatelessWidget {
  final List<Emoji> emojis;
  final String? selectedEmoji;
  final Function(String) onEmojiSelected;

  const MoodEmojiSelector({
    super.key,
    required this.emojis,
    required this.selectedEmoji,
    required this.onEmojiSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: emojis.length,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.all(1.r),
          child: CustomMood(
            backgroundColor: selectedEmoji == emojis[index].name
                ? AppTheme.blue
                : null,
            onPressed: () => onEmojiSelected(emojis[index].name),
            emoji: emojis[index].toString(),
          ),
        ),
      ),
    );
  }
}
