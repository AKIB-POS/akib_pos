import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/accounting/presentation/pages/accounting_page.dart';
import 'package:akib_pos/features/cashier/presentation/pages/cashier_page.dart';
import 'package:akib_pos/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:akib_pos/features/settings/presentation/pages/settings_page.dart';
import 'package:akib_pos/features/stockist/presentation/pages/stockist_page.dart';
import 'package:akib_pos/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:device_preview/device_preview.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart'; // Import for setting orientation
import 'firebase_options.dart'; // Make sure to generate this file using Firebase CLI
import 'common/my_app_sidebar.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
//enable device preview
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (_) => const MyApp(),
    ),
  );
//disable device preview
  //  runApp(
  //    MyApp()
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => Sizer(
        builder: (BuildContext context, orientation, deviceType) => MaterialApp(
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          title: 'MyApp',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: primaryColor,
            canvasColor: canvasColor,
            scaffoldBackgroundColor: scaffoldBackgroundColor,
          ),
          home: const HomeScreen(),
        ),
      );
}

