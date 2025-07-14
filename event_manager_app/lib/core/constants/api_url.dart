class ApiUrl {
  static const baseUrl = 'http://localhost:8000/';
  
  // Auth endpoints
  static const login = 'api/v1/auth/login/';
  static const register = 'api/v1/auth/register/';
  
  // Event endpoints
  static const events = 'api/v1/events/';
  static const hotEvents = 'api/v1/events/hot';
  static const monthlyEvents = 'api/v1/events/monthly';
  static const upcomingEvents = 'api/v1/events/upcoming';
  static const searchEvents = 'api/v1/events/search';
  
  // Dynamic event endpoints (with ID)
  static String eventById(int id) => 'api/v1/events/$id';
  static String eventWithOrganizer(int id) => 'api/v1/events/$id/with-organizer';
  static String eventStatus(int id) => 'api/v1/events/$id/status';
  static String eventsByOrganizer(int organizerId) => 'api/v1/events/by-organizer/$organizerId';
  static String eventTickets(int eventId) => 'api/v1/events/$eventId/tickets';
  
  // Bulk operations
  static const bulkPublishEvents = 'api/v1/events/bulk-publish';
}