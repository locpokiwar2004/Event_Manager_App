import 'package:event_manager_app/core/network/dio_client.dart';
import 'package:event_manager_app/data/repository/auth.dart';
import 'package:event_manager_app/data/source/auth_api_service.dart';
import 'package:event_manager_app/domain/repository/auth.dart';
import 'package:event_manager_app/domain/usecases/signup.dart';
import 'package:event_manager_app/domain/usecases/login.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupServerLocator() {
  // Core
  sl.registerSingleton<DioClient>(DioClient());
  
  // Data Sources
  sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());
  
  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  
  // Use Cases
  sl.registerSingleton<SingupUsecase>(SingupUsecase());
  sl.registerSingleton<LoginUsecase>(LoginUsecase());
}