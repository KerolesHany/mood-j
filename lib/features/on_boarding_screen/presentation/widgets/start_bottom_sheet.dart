import 'package:flutter/material.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/widgets/registration_bottom_sheet_content.dart';

Future<dynamic> startBottomSheet({
  required BuildContext context,
  required GlobalKey<FormState> globalKey,
  required TextEditingController nameController,
}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return RegistrationBottomSheetContent(
        formKey: globalKey,
        nameController: nameController,
      );
    },
  );
}
