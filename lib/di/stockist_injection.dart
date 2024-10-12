import 'package:akib_pos/features/stockist/data/datasources/stockist_remote_data_source.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/add_equipment_stock_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/add_equipment_type_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/add_material_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/add_raw_material_stock_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/add_vendor.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/expired_stock_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_equipment_detail_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_equipment_purchase_history_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_equipment_type_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_equipment_purchase_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_order_status_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_raw_material_purchase_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_raw_material_purchase_history_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_raw_material_type_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_unit_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_vendor_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_warehouses_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/material_detail_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/running_out_stock_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/stockist_recent_purchase_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/stockist_summary_cubit.dart';
import 'package:get_it/get_it.dart';

final stockistInjection = GetIt.instance;

Future<void> initStockistModule() async {
  //! Features - Stockist
  // Remote Data Source
  stockistInjection.registerLazySingleton<StockistRemoteDataSource>(
    () => StockistRemoteDataSourceImpl(client: stockistInjection()),
  );

  // Repository
  stockistInjection.registerLazySingleton<StockistRepository>(
    () => StockistRepositoryImpl(remoteDataSource: stockistInjection()),
  );

  // Cubit
  stockistInjection.registerFactory(
    () => StockistSummaryCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => StockistRecentPurchasesCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => ExpiredStockCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => RunningOutStockCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => GetVendorCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => AddVendorCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => GetRawMaterialTypeCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => AddRawMaterialCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => AddEquipmentTypeCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => GetRawMaterialPurchaseCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => GetMaterialDetailCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => GetRawMaterialPurchaseHistoryCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => GetUnitCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => GetWarehousesCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => GetOrderStatusCubit(stockistInjection()),
  );
   stockistInjection.registerFactory(
    () => AddRawMaterialStockCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => GetEquipmentTypeCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => GetEquipmentPurchaseCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => GetEquipmentDetailCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => GetEquipmentPurchaseHistoryCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => AddEquipmentStockCubit(stockistInjection()),
  );
  


}
  
