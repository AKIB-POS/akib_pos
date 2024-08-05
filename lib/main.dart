import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/cashier/presentation/pages/cashier_page.dart';
import 'package:akib_pos/features/home/cubit/navigation_cubit.dart';
import 'package:akib_pos/routes/app_routes.dart';
import 'package:akib_pos/features/cashier/presentation/pages/cashier_landscape.dart';
import 'package:akib_pos/features/cashier/presentation/pages/cashier_portrait.dart';
import 'package:akib_pos/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:akib_pos/features/settings/presentation/pages/settings_page.dart';
import 'package:akib_pos/features/stockist/presentation/pages/stockist_page.dart';
import 'package:akib_pos/features/home/home_screen.dart';
import 'package:akib_pos/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
//enable device preview
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (_) => BlocProvider(
        create: (context) => NavigationCubit(),
        child: MyApp(),
      ),
    ),
  );

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-Module App',
      theme: ThemeData(
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
        primaryColor: AppColors.primaryMain,
      ),
      home: const SplashScreen(),
    );
  }
}
