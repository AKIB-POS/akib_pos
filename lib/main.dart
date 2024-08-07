import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:akib_pos/features/home/cubit/navigation_cubit.dart';
import 'package:akib_pos/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
//disable device preview
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider(
          create: (context) => CashierCubit(),
        ),
      ],
      child: MyApp(),
    ),
  );
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (_) => MultiBlocProvider(
  //       providers: [
  //         BlocProvider(
  //           create: (context) => NavigationCubit(),
  //         ),
  //         BlocProvider(
  //           create: (context) => CashierCubit(),
  //         ),
  //       ],
  //       child: MyApp(),
  //     ),
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Multi-Module App',
          theme: ThemeData(
            textTheme: GoogleFonts.plusJakartaSansTextTheme(),
            primaryColor: AppColors.primaryMain,
          ),
          home: const SplashScreen(),
        );
      }
    );
  }
}
