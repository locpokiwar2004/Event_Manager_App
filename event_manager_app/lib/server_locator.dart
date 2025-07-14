import 'package:event_manager_app/core/network/dio_client.dart';
import 'package:event_manager_app/data/repository/auth.dart';
import 'package:event_manager_app/data/source/auth_api_service.dart';
import 'package:event_manager_app/domain/repository/auth.dart';
import 'package:event_manager_app/domain/usecases/signup.dart';
import 'package:event_manager_app/domain/usecases/login.dart';
import 'package:event_manager_app/data/source/ticket_remote_data_source.dart';
import 'package:event_manager_app/data/repository/ticket_repository_impl.dart';
import 'package:event_manager_app/domain/repository/ticket_repository.dart';
import 'package:event_manager_app/domain/usecases/ticket_use_cases.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupServerLocator() {
  // Core (only register if not already registered)
  if (!sl.isRegistered<DioClient>()) {
    sl.registerSingleton<DioClient>(DioClient());
  }
  
  // Data Sources for Authentication
  sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());
  
  // Repositories for Authentication
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  
  // Use Cases for Authentication
  sl.registerSingleton<SingupUsecase>(SingupUsecase());
  sl.registerSingleton<LoginUsecase>(LoginUsecase());
  
  // Data Sources for Tickets
  sl.registerSingleton<TicketRemoteDataSource>(
    TicketRemoteDataSourceImpl(dio: sl<DioClient>().dio)
  );
  
  // Repositories for Tickets
  sl.registerSingleton<TicketRepository>(
    TicketRepositoryImpl(remoteDataSource: sl<TicketRemoteDataSource>())
  );
  
  // Use Cases for Tickets
  sl.registerSingleton<GetEventTickets>(GetEventTickets(sl<TicketRepository>()));
  sl.registerSingleton<CreateTicket>(CreateTicket(sl<TicketRepository>()));
  sl.registerSingleton<GetAllTickets>(GetAllTickets(sl<TicketRepository>()));
}