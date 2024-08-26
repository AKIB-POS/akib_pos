import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/di/injection_container.dart';
import 'package:akib_pos/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/badge/badge_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/close_cashier/close_cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/expenditure/expenditure_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/member/member_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/open_cashier/open_cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/printer/printer_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/product/product_bloc.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/process_transaction_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/transaction_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/voucher/voucher_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/checkout/checkout_cubit.dart';
import 'package:akib_pos/features/home/cubit/navigation_cubit.dart';
import 'package:akib_pos/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:akib_pos/di/injection_container.dart' as di;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   await _requestPermissions(); 
  await di.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider(
          create: (context) => ProductBloc(
            kasirRepository: sl(),
            localDataSource: sl(),
          )
            ..add(FetchCategoriesEvent())
            ..add(FetchSubCategoriesEvent())
            ..add(FetchProductsEvent())
            ..add(FetchAdditionsEvent())
            ..add(FetchVariantsEvent()),
        ),
        // BlocProvider(
        //   create: (context) => AuthBloc(
        //      sl(),
        //   ),
        // ),
        BlocProvider(
          create: (context) => CashierCubit(
            localDataSource: sl(),
            productBloc: sl<ProductBloc>(),
          )..loadData(),
        ),
        BlocProvider(
            create: (context) =>
                TransactionCubit(sl())), // Ensure this is provided here
        BlocProvider(
            create: (context) =>
                ProcessTransactionCubit()), // Ensure this is provided here
        BlocProvider(
            create: (context) =>
                VoucherCubit(sl())), // Ensure this is provided here
        BlocProvider(
            create: (context) =>
                BadgeCubit(sl())), // Ensure this is provided here
        BlocProvider(
            create: (context) =>
                CheckoutCubit(sl())), // Ensure this is provided here
        BlocProvider(
            create: (context) =>
                MemberCubit(repository: sl())),
        BlocProvider(
            create: (context) =>
                CloseCashierCubit(repository: sl())),
        BlocProvider(
            create: (context) =>
                OpenCashierCubit(repository: sl())),
        BlocProvider(
            create: (context) =>
                ExpenditureCubit(repository: sl())),
        BlocProvider(
            create: (context) =>
                AuthCubit(sl())),
        BlocProvider(
            create: (context) =>
                PrinterCubit(bluetooth: sl(),sharedPreferences: sl())),
      ],
      child: MyApp(),
    ),
  );
}

Future<void> _requestPermissions() async {
  // Request Bluetooth and Location Permissions
  PermissionStatus bluetoothStatus = await Permission.bluetooth.status;
  PermissionStatus locationStatus = await Permission.location.status;

  if (!bluetoothStatus.isGranted) {
    await Permission.bluetooth.request();
  }

  if (!locationStatus.isGranted) {
    await Permission.location.request();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Multi-Module App',
          theme: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor:
                  AppColors.primaryMain, // Warna kursor di seluruh aplikasi
              selectionColor: AppColors.primaryMain
                  .withOpacity(0.5), // Warna selection (highlight)
              selectionHandleColor:
                  AppColors.primaryMain, // Warna handle selection
            ),
            textTheme: GoogleFonts.plusJakartaSansTextTheme(),
            primaryColor: AppColors.primaryMain,
            indicatorColor: AppColors.primaryMain,
   progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primaryMain, // Warna progress indicator
        ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
