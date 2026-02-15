import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moodly_j/core/theme/app_theme.dart';
import 'package:moodly_j/features/on_boarding_screen/domain/enitities/user_entity.dart';

class UserHeaderSection extends StatelessWidget {
  final UserEntity? user;
  final Function(String) onImagePicked;

  const UserHeaderSection({
    super.key,
    required this.user,
    required this.onImagePicked,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: () async {
              final ImagePicker picker = ImagePicker();
              final imgUrl = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (imgUrl == null) return;
              onImagePicked(imgUrl.path);
            },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 70.r,
                  backgroundImage: (user?.imgPath == null ||
                          user!.imgPath.isEmpty ||
                          user!.imgPath == "assets/icons/person.png")
                      ? const AssetImage("assets/icons/person.png")
                      : FileImage(File(user!.imgPath))
                          as ImageProvider,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: AppTheme.blue,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(8.r),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          user?.name ?? "",
          style: textTheme.titleMedium!.copyWith(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.black,
          ),
        ),
      ],
    );
  }
}
