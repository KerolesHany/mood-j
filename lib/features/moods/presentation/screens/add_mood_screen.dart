import 'dart:io';
import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moodly_j/core/our_emojis.dart';
import 'package:moodly_j/core/ui/ui_uitils.dart';
import 'package:moodly_j/features/home/presentation/home_screen.dart';
import 'package:moodly_j/features/moods/domain/entities/mood_entity.dart';
import 'package:moodly_j/features/moods/presentation/cubit/moods_cubti.dart';
import 'package:moodly_j/features/moods/presentation/widgets/custom_audio_player.dart';
import 'package:moodly_j/features/moods/presentation/widgets/feature_lable.dart';
import 'package:moodly_j/features/moods/presentation/widgets/feeling_input_field.dart';
import 'package:moodly_j/features/moods/presentation/widgets/voice_recorder.dart';
import 'package:moodly_j/l10n/app_localizations.dart';

import 'package:moodly_j/features/moods/presentation/widgets/mood_emoji_selector.dart';
import 'package:moodly_j/features/moods/presentation/widgets/mood_attachment_section.dart';
import 'package:moodly_j/features/moods/presentation/widgets/save_mood_button.dart';

class AddMoodScreen extends StatefulWidget {
  static const String routeName = "AddMoodScreen";
  const AddMoodScreen({super.key});
  @override
  State<AddMoodScreen> createState() => _AddMoodScreenState();
}

class _AddMoodScreenState extends State<AddMoodScreen> {
  TextEditingController descriptionController = TextEditingController();
  String? selectedEmoji;
  XFile? selectedImg;
  File? recorededFile;
  bool emojiSelected = false;
  List<Emoji> emojis = [
    OurEmojis.angry,
    OurEmojis.happy,
    OurEmojis.calm,
    OurEmojis.excited,
    OurEmojis.boring,
    OurEmojis.sad,
  ];

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.all(12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //! Input Field
              FeelingInputField(controller: descriptionController),
              SizedBox(height: 10.h),
              FeatureLable(lable: localization.howsYourMood),
              //! Emojiis
              MoodEmojiSelector(
                emojis: emojis,
                selectedEmoji: selectedEmoji,
                onEmojiSelected: (emoji) {
                  setState(() {
                    selectedEmoji = emoji;
                  });
                },
              ),
              SizedBox(height: 20.h),
              FeatureLable(lable: localization.attachments),
              SizedBox(height: 8.h),
              //! Add Photo & Voice
              MoodAttachmentSection(
                selectedImg: selectedImg,
                recorededFile: recorededFile,
                onPickImage: pickImage,
                onRecordVoice: recordVoice,
                onShowRecordedVoice: () {
                  showRecordedVoice(context);
                },
              ),
              SizedBox(height: 6.h),
              Spacer(),
              SaveMoodButton(onPressed: addMood),
              SizedBox(height: 10.h),
            ],
          ),
        ),
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.of(
              context,
            ).pushReplacementNamed(HomeScreen.routeName),
            child: const Icon(Icons.arrow_back),
          ),
          title: Text(
            localization.addMood,
            style: textTheme.titleLarge!.copyWith(fontSize: 24.sp),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showRecordedVoice(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomAudioPlayer(recorededFile: File(recorededFile!.path)),
            ],
          ),
        );
      },
    );
  }

  Future<void> addMood() async {
    if (descriptionController.text.trim().isEmpty || selectedEmoji == null) {
      UiUtils.showMessage(
        context,
        AppLocalizations.of(context)!.descriptionAndEmojiRequired,
        false,
      );
    } else {
      final moodEntity = MoodEntity(
        description: descriptionController.text,
        emoji: selectedEmoji ?? "",
        audioPath: recorededFile?.path ?? "",
        imgPath: selectedImg?.path ?? "",
        moodDate: DateTime.now(),
      );
      await BlocProvider.of<MoodsCubit>(
        context,
      ).addMood(moodEntity: moodEntity);
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    selectedImg = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<void> recordVoice() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Spacer(),
              Row(
                children: [
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: VoiceRecorder(
                      onRecorded: (file) async {
                        recorededFile = file;
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    setState(() {});
  }
}
