import 'package:dartz/dartz.dart';
import 'package:event_manager_app/core/error/failures.dart';
import 'package:event_manager_app/domain/entities/event.dart';

abstract class EventRepository {
  // Get all events
  Future<Either<Failure, List<EventEntity>>> getEvents();
  
  // Get event by ID
  Future<Either<Failure, EventEntity>> getEventById(int id);
  
  // Get event with organizer info
  Future<Either<Failure, EventWithOrganizerEntity>> getEventWithOrganizer(int id);
  
  // Get hot events
  Future<Either<Failure, List<EventEntity>>> getHotEvents({int? limit});
  
  // Get upcoming events
  Future<Either<Failure, List<EventEntity>>> getUpcomingEvents({int? limit});
  
  // Get monthly events
  Future<Either<Failure, List<EventEntity>>> getMonthlyEvents({
    required int year,
    required int month,
  });
  
  // Search events
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
  });
  
  // Get events by organizer
  Future<Either<Failure, List<EventEntity>>> getEventsByOrganizer(int organizerId);
  
  // Create event
  Future<Either<Failure, EventEntity>> createEvent(EventEntity event);
  
  // Update event
  Future<Either<Failure, EventEntity>> updateEvent(EventEntity event);
  
  // Delete event
  Future<Either<Failure, void>> deleteEvent(int id);
  
  // Update event status
  Future<Either<Failure, EventEntity>> updateEventStatus(int id, String status);
  
  // Bulk publish events
  Future<Either<Failure, List<EventEntity>>> bulkPublishEvents(List<int> eventIds);
}
