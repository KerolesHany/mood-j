import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodly_j/core/service/local_notifications.dart';
import 'package:moodly_j/core/service_locator/get_it.dart';
import 'package:moodly_j/features/home/presentation/home_screen.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/cubit/user_cubit.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/cubit/user_states.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/screens/on_boarding_screen.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});
  static const String routeName = "InitScreen";

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  void initState() {
    getIt<UserCubit>().isUserCreated();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<UserCubit, UserStates>(
        listener: (context, state) {
          if (state is SuccessIsUserCreatedStateState) {
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          } else if (state is ErrorIsUserCreatedState) {
            Navigator.of(
              context,
            ).pushReplacementNamed(OnBoardingScreen.routeName);
          }
        },
        builder: (_, state) {
          if (state is LoadingIsUserCreatedState) {
            return Center(child: CircularProgressIndicator());
          }
          return Container(color: Colors.white, height: 200.h);
        },
      ),
    );
  }

  Future init(BuildContext context) async {
    final result = await LocalNotifications.requestPermission();
    if (result) {
      await LocalNotifications.init();
      // await LocalNotifications.s;
    } else {
      await LocalNotifications.cancel();
    }
  }
}
