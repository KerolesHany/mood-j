import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodly_j/core/bloc_observer.dart';
import 'package:moodly_j/core/routes/app_routes.dart';
import 'package:moodly_j/core/service_locator/get_it.dart';
import 'package:moodly_j/core/theme/app_theme.dart';
import 'package:moodly_j/features/moods/presentation/cubit/moods_cubti.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/cubit/user_cubit.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/init_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moodly_j/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  setup();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<MoodsCubit>()
            ..getMoodToday()
            ..getMostFrequentMood()
            ..getWritingStreak()
            ..getAllMoods(),
        ),
        BlocProvider(
          create: (context) => getIt<UserCubit>()
            ..isUserCreated()
            ..getUser(),
        ),
      ],
      child: const MoodJApp(),
    ),
  );
}

class MoodJApp extends StatefulWidget {
  const MoodJApp({super.key});

  @override
  State<MoodJApp> createState() => _MoodJAppState();
}

class _MoodJAppState extends State<MoodJApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      splitScreenMode: true,
      designSize: const Size(360, 640),
      minTextAdapt: true,
      ensureScreenSize: true,
      builder: (context, child) => MaterialApp(
        locale: Locale(context.watch<UserCubit>().user?.language ?? "en"),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('ar'), Locale('en'), 
        ],
        debugShowCheckedModeBanner: false,
        initialRoute: InitScreen.routeName,
        routes: AppRoutes.routes,
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
