import 'package:event_manager_app/data/models/event_model.dart';

abstract class EventRemoteDataSource {
  // Get all events
  Future<List<EventModel>> getEvents();
  
  // Get event by ID
  Future<EventModel> getEventById(int id);
  
  // Get event with organizer info
  Future<EventWithOrganizerModel> getEventWithOrganizer(int id);
  
  // Get hot events
  Future<List<EventModel>> getHotEvents({int? limit});
  
  // Get upcoming events
  Future<List<EventModel>> getUpcomingEvents({int? limit});
  
  // Get monthly events
  Future<List<EventModel>> getMonthlyEvents({
    required int year,
    required int month,
  });
  
  // Search events
  Future<List<EventModel>> searchEvents({
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
  Future<List<EventModel>> getEventsByOrganizer(int organizerId);
  
  // Create event
  Future<EventModel> createEvent(EventModel event);
  
  // Update event
  Future<EventModel> updateEvent(EventModel event);
  
  // Delete event
  Future<void> deleteEvent(int id);
  
  // Update event status
  Future<EventModel> updateEventStatus(int id, String status);
  
  // Bulk publish events
  Future<List<EventModel>> bulkPublishEvents(List<int> eventIds);
}
