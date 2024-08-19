import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/di/injection_container.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/badge/badge_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/member/member_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/product/product_bloc.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/process_transaction_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/transaction_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/voucher/voucher_cubit.dart';
import 'package:akib_pos/features/home/cubit/navigation_cubit.dart';
import 'package:akib_pos/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:akib_pos/di/injection_container.dart' as di;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
                MemberCubit(repository: sl())),
      ],
      child: MyApp(),
    ),
  );
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
