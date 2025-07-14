import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_manager_app/core/di/injection_container.dart';
import 'package:event_manager_app/domain/entities/event.dart';
import 'package:event_manager_app/domain/usecases/get_events.dart';
import 'package:event_manager_app/domain/usecases/get_hot_events.dart';
import 'package:event_manager_app/domain/usecases/get_upcoming_events.dart';
import 'package:event_manager_app/domain/usecases/get_monthly_events.dart';
import 'package:event_manager_app/domain/usecases/search_events.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final GetEventsUseCase getEventsUseCase;
  final GetHotEventsUseCase getHotEventsUseCase;
  final GetUpcomingEventsUseCase getUpcomingEventsUseCase;
  final GetMonthlyEventsUseCase getMonthlyEventsUseCase;
  final SearchEventsUseCase searchEventsUseCase;

  EventCubit({
    required this.getEventsUseCase,
    required this.getHotEventsUseCase,
    required this.getUpcomingEventsUseCase,
    required this.getMonthlyEventsUseCase,
    required this.searchEventsUseCase,
  }) : super(EventInitial());

  // Factory constructor for easy dependency injection
  factory EventCubit.create() => EventCubit(
        getEventsUseCase: sl<GetEventsUseCase>(),
        getHotEventsUseCase: sl<GetHotEventsUseCase>(),
        getUpcomingEventsUseCase: sl<GetUpcomingEventsUseCase>(),
        getMonthlyEventsUseCase: sl<GetMonthlyEventsUseCase>(),
        searchEventsUseCase: sl<SearchEventsUseCase>(),
      );

  Future<void> getAllEvents() async {
    emit(EventLoading());
    
    final result = await getEventsUseCase(NoParams());
    
    result.fold(
      (failure) => emit(EventError(message: failure.message)),
      (events) => emit(EventLoaded(events: events)),
    );
  }

  Future<void> getHotEvents({int? limit}) async {
    try {
      emit(EventLoading());
      print('EventCubit: Loading hot events with limit: ${limit ?? 10}');
      
      final result = await getHotEventsUseCase(GetHotEventsParams(limit: limit ?? 10));
      
      result.fold(
        (failure) {
          print('EventCubit: Error loading hot events: ${failure.message}');
          emit(EventError(message: failure.message));
        },
        (events) {
          print('EventCubit: Successfully loaded ${events.length} hot events');
          emit(EventLoaded(events: events));
        },
      );
    } catch (e) {
      print('EventCubit: Exception in getHotEvents: $e');
      emit(EventError(message: 'Unexpected error: $e'));
    }
  }

  Future<void> getUpcomingEvents({int? limit}) async {
    emit(EventLoading());
    
    final result = await getUpcomingEventsUseCase(GetUpcomingEventsParams(limit: limit));
    
    result.fold(
      (failure) => emit(EventError(message: failure.message)),
      (events) => emit(EventLoaded(events: events)),
    );
  }

  Future<void> searchEvents({
    String? query,
    String? category,
    String? location,
    DateTime? dateFrom,
    DateTime? dateTo,
    double? minPrice,
    double? maxPrice,
    int? limit,
    int? offset,
  }) async {
    emit(EventLoading());
    
    final result = await searchEventsUseCase(EventSearchParams(
      query: query,
      category: category,
      location: location,
      dateFrom: dateFrom,
      dateTo: dateTo,
      minPrice: minPrice,
      maxPrice: maxPrice,
      limit: limit,
      offset: offset,
    ));
    
    result.fold(
      (failure) => emit(EventError(message: failure.message)),
      (events) => emit(EventLoaded(events: events)),
    );
  }

  Future<void> getMonthlyEvents({required int year, required int month}) async {
    try {
      emit(EventLoading());
      print('EventCubit: Loading monthly events for $year-$month');
      
      final result = await getMonthlyEventsUseCase(MonthlyEventsParams(
        year: year,
        month: month,
      ));
      
      result.fold(
        (failure) {
          print('EventCubit: Error loading monthly events: ${failure.message}');
          emit(EventError(message: failure.message));
        },
        (events) {
          print('EventCubit: Successfully loaded ${events.length} monthly events');
          emit(EventLoaded(events: events));
        },
      );
    } catch (e) {
      print('EventCubit: Exception in getMonthlyEvents: $e');
      emit(EventError(message: 'Unexpected error: $e'));
    }
  }
}
