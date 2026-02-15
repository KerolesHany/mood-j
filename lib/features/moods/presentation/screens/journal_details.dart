import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodly_j/core/theme/app_theme.dart';
import 'package:moodly_j/features/moods/domain/entities/mood_entity.dart';
import 'package:moodly_j/features/moods/presentation/widgets/journal_detail_content.dart';

// ignore: must_be_immutable
class JournalDetailsScreen extends StatefulWidget {
  static const routeName = "JournalDetails";
  const JournalDetailsScreen({super.key});

  @override
  State<JournalDetailsScreen> createState() => _JournalDetailsScreenState();
}

class _JournalDetailsScreenState extends State<JournalDetailsScreen> {
  bool isLoaded = false;
  MoodEntity? mood;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      mood = ModalRoute.of(context)!.settings.arguments as MoodEntity;
      isLoaded = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Color(0xffE7E7F1),
      appBar: AppBar(
        title: Text(
          "Your Mood",
          style: textTheme.titleMedium!.copyWith(color: AppTheme.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: mood != null
            ? JournalDetailContent(mood: mood, isLoaded: isLoaded)
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
