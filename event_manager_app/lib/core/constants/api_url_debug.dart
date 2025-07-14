class ApiUrl {
  static const baseUrl = 'http://192.168.2.32:8000/';
  
  // Auth endpoints
  static const login = 'api/v1/auth/login/';
  static const register = 'api/v1/auth/register/';
  
  // Event endpoints
  static const events = 'api/v1/events/';
  static const hotEvents = 'api/v1/events/hot';
  static const upcomingEvents = 'api/v1/events/upcoming';
  static const monthlyEvents = 'api/v1/events/monthly';
  static const searchEvents = 'api/v1/events/search';
  
  // Ticket endpoints
  static const tickets = 'api/v1/tickets/';
  
  // Order endpoints
  static const orders = 'api/v1/orders/';
  
  // Payment endpoints
  static const payments = 'api/v1/payments/';
}
