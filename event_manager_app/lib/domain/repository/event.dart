import 'package:dartz/dartz.dart';
import '../entities/event.dart';

abstract class EventRepository {
  // Get all events
  Future<Either<String, List<EventEntity>>> getEvents();
  
  // Get event by ID
  Future<Either<String, EventEntity>> getEventById(int eventId);
  
  // Get event with organizer info
  Future<Either<String, EventWithOrganizerEntity>> getEventWithOrganizer(int eventId);
  
  // Get hot events
  Future<Either<String, List<EventEntity>>> getHotEvents({int limit = 10});
  
  // Get events by month
  Future<Either<String, List<EventEntity>>> getEventsByMonth(MonthlyEventsEntity params);
  
  // Get upcoming events
  Future<Either<String, List<EventEntity>>> getUpcomingEvents({
    int days = 7,
    int limit = 20,
    String? category,
  });
  
  // Search events
  Future<Either<String, List<EventEntity>>> searchEvents(EventSearchEntity params);
  
  // Get events by organizer
  Future<Either<String, List<EventEntity>>> getEventsByOrganizer({
    required int organizerId,
    EventStatus? status,
    int limit = 50,
  });
  
  // Create event
  Future<Either<String, EventEntity>> createEvent({
    required String title,
    required String description,
    required String category,
    required String location,
    String? img,
    required DateTime startTime,
    required DateTime endTime,
    required int capacity,
    required int organizerId,
  });
  
  // Update event
  Future<Either<String, EventEntity>> updateEvent({
    required int eventId,
    String? title,
    String? description,
    String? category,
    String? location,
    String? img,
    DateTime? startTime,
    DateTime? endTime,
    int? capacity,
    EventStatus? status,
  });
  
  // Update event status
  Future<Either<String, EventEntity>> updateEventStatus({
    required int eventId,
    required EventStatus status,
  });
  
  // Delete event
  Future<Either<String, bool>> deleteEvent(int eventId);
  
  // Bulk publish events
  Future<Either<String, Map<String, dynamic>>> bulkPublishEvents(List<int> eventIds);
}