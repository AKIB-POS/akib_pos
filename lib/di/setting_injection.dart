import 'package:akib_pos/features/settings/data/datasources/setting_remote_data_source.dart';
import 'package:akib_pos/features/settings/data/repositories/setting_repository.dart';
import 'package:akib_pos/features/settings/presentation/bloc/change_password_cubit.dart';
import 'package:akib_pos/features/settings/presentation/bloc/get_personal_information_cubit.dart';
import 'package:get_it/get_it.dart';

final settingInjection = GetIt.instance;

Future<void> initSettingModule() async {
  //! Features - Setting
  // Remote Data Source
  settingInjection.registerLazySingleton<SettingRemoteDataSource>(
    () => SettingRemoteDataSourceImpl(client: settingInjection()),
  );

  // Repository
  settingInjection.registerLazySingleton<SettingRepository>(
    () => SettingRepositoryImpl(
      remoteDataSource: settingInjection(),
      connectivity: settingInjection(),
    ),
  );

  // Cubit
  settingInjection.registerFactory(
    () => GetPersonalInformationCubit(settingInjection()),
  );
  settingInjection.registerFactory(
    () => ChangePasswordCubit(settingInjection()), // Register ChangePasswordCubit
  );
}
