import 'package:get_it/get_it.dart';
import 'package:event_manager_app/core/network/dio_client.dart';
import 'package:event_manager_app/data/repository/event_repository_impl.dart';
import 'package:event_manager_app/data/source/event_remote_data_source.dart';
import 'package:event_manager_app/data/source/event_remote_data_source_impl.dart';
import 'package:event_manager_app/domain/repository/event_repository.dart';
import 'package:event_manager_app/domain/usecases/get_events.dart';
import 'package:event_manager_app/domain/usecases/get_hot_events.dart';
import 'package:event_manager_app/domain/usecases/get_monthly_events.dart';
import 'package:event_manager_app/domain/usecases/get_upcoming_events.dart';
import 'package:event_manager_app/domain/usecases/search_events.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => DioClient());

  // Data sources
  sl.registerLazySingleton<EventRemoteDataSource>(
    () => EventRemoteDataSourceImpl(dioClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetEventsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetHotEventsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetUpcomingEventsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetMonthlyEventsUseCase(repository: sl()));
  sl.registerLazySingleton(() => SearchEventsUseCase(repository: sl()));
}
