import 'package:dartz/dartz.dart';
import 'package:event_manager_app/core/error/failures.dart';
import 'package:event_manager_app/data/models/event_model.dart';
import 'package:event_manager_app/data/source/event_remote_data_source.dart';
import 'package:event_manager_app/domain/entities/event.dart';
import 'package:event_manager_app/domain/repository/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<EventEntity>>> getEvents() async {
    try {
      final eventModels = await remoteDataSource.getEvents();
      final eventEntities = eventModels.map((model) => model.toEntity()).toList();
      return Right(eventEntities);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> getEventById(int id) async {
    try {
      final eventModel = await remoteDataSource.getEventById(id);
      return Right(eventModel.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, EventWithOrganizerEntity>> getEventWithOrganizer(int id) async {
    try {
      final eventWithOrganizerModel = await remoteDataSource.getEventWithOrganizer(id);
      return Right(eventWithOrganizerModel.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<EventEntity>>> getHotEvents({int? limit}) async {
    try {
      final eventModels = await remoteDataSource.getHotEvents(limit: limit);
      final eventEntities = eventModels.map((model) => model.toEntity()).toList();
      return Right(eventEntities);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<EventEntity>>> getUpcomingEvents({int? limit}) async {
    try {
      final eventModels = await remoteDataSource.getUpcomingEvents(limit: limit);
      final eventEntities = eventModels.map((model) => model.toEntity()).toList();
      return Right(eventEntities);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<EventEntity>>> getMonthlyEvents({
    required int year,
    required int month,
  }) async {
    try {
      final eventModels = await remoteDataSource.getMonthlyEvents(
        year: year,
        month: month,
      );
      final eventEntities = eventModels.map((model) => model.toEntity()).toList();
      return Right(eventEntities);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<EventEntity>>> searchEvents({
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
    try {
      final eventModels = await remoteDataSource.searchEvents(
        query: query,
        category: category,
        location: location,
        dateFrom: dateFrom,
        dateTo: dateTo,
        minPrice: minPrice,
        maxPrice: maxPrice,
        limit: limit,
        offset: offset,
      );
      final eventEntities = eventModels.map((model) => model.toEntity()).toList();
      return Right(eventEntities);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<EventEntity>>> getEventsByOrganizer(int organizerId) async {
    try {
      final eventModels = await remoteDataSource.getEventsByOrganizer(organizerId);
      final eventEntities = eventModels.map((model) => model.toEntity()).toList();
      return Right(eventEntities);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> createEvent(EventEntity event) async {
    try {
      final eventModel = await remoteDataSource.createEvent(
        EventModel.fromEntity(event),
      );
      return Right(eventModel.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> updateEvent(EventEntity event) async {
    try {
      final eventModel = await remoteDataSource.updateEvent(
        EventModel.fromEntity(event),
      );
      return Right(eventModel.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(int id) async {
    try {
      await remoteDataSource.deleteEvent(id);
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> updateEventStatus(int id, String status) async {
    try {
      final eventModel = await remoteDataSource.updateEventStatus(id, status);
      return Right(eventModel.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<EventEntity>>> bulkPublishEvents(List<int> eventIds) async {
    try {
      final eventModels = await remoteDataSource.bulkPublishEvents(eventIds);
      final eventEntities = eventModels.map((model) => model.toEntity()).toList();
      return Right(eventEntities);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(dynamic exception) {
    final message = exception.toString();
    
    if (message.contains('Connection timeout') || 
        message.contains('timeout')) {
      return NetworkFailure(message: 'Connection timeout. Please check your internet connection.');
    } else if (message.contains('Network connection error') || 
               message.contains('SocketException')) {
      return NetworkFailure(message: 'Network error. Please check your internet connection.');
    } else if (message.contains('Server error (404)')) {
      return NotFoundFailure(message: 'Resource not found.');
    } else if (message.contains('Server error (401)')) {
      return AuthFailure(message: 'Authentication failed. Please log in again.');
    } else if (message.contains('Server error (403)')) {
      return AuthFailure(message: 'Access denied. You do not have permission.');
    } else if (message.contains('Server error')) {
      return ServerFailure(message: 'Server error. Please try again later.');
    } else {
      return UnknownFailure(message: 'An unexpected error occurred: $message');
    }
  }
}
