import 'dart:convert';
import 'package:http/http.dart' as http;

class EventService {
  static const String baseUrl = 'http://localhost:8000/api/v1';
  
  static Future<Map<String, dynamic>> createEvent({
    required String title,
    required String description,
    required String category,
    required String location,
    required String date,
    required String time,
    required int capacity,
    required double price,
    int organizerId = 1,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/events'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'category': category,
          'location': location,
          'date': date,
          'time': time,
          'capacity': capacity,
          'price': price,
          'organizer_id': organizerId,
        }),
      );

      print('Create Event Response Status: ${response.statusCode}');
      print('Create Event Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final eventData = jsonDecode(response.body);
        // Convert to expected format for CreateTicketsScreen
        final convertedEvent = {
          'EventID': eventData['id'],
          'Title': eventData['title'],
          'Description': eventData['description'],
          'Category': eventData['category'],
          'Location': eventData['location'],
          'StartTime': '${eventData['date']}T${eventData['time']}:00',
          'EndTime': '${eventData['date']}T${eventData['time']}:00',
          'Capacity': eventData['capacity'],
          'Price': eventData['price'],
          'OrganizerID': eventData['organizer_id'],
          'CreatedAt': eventData['created_at'],
        };
        
        return {
          'success': true,
          'data': convertedEvent,
          'message': 'Event created successfully!'
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['detail'] ?? 'Failed to create event'
        };
      }
    } catch (e) {
      print('Create Event Error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}'
      };
    }
  }

  static Future<Map<String, dynamic>> getAllEvents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/events/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Get Events Response Status: ${response.statusCode}');
      print('Get Events Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch events'
        };
      }
    } catch (e) {
      print('Get Events Error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}'
      };
    }
  }

  static Future<Map<String, dynamic>> getEvent(int eventId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/events/$eventId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Get Event Response Status: ${response.statusCode}');
      print('Get Event Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch event'
        };
      }
    } catch (e) {
      print('Get Event Error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}'
      };
    }
  }

  static Future<Map<String, dynamic>> getEventsByOrganizer(int organizerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/events/by-organizer/$organizerId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Get Events by Organizer Response Status: ${response.statusCode}');
      print('Get Events by Organizer Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> events = jsonDecode(response.body);
        // Convert API format to match expected format
        final List<Map<String, dynamic>> convertedEvents = events.map((event) {
          return {
            'EventID': event['EventID'] ?? event['id'], // Handle both formats
            'Title': event['Title'] ?? event['title'],
            'Description': event['Description'] ?? event['description'],
            'Category': event['Category'] ?? event['category'],
            'Location': event['Location'] ?? event['location'],
            'StartTime': event['StartTime'] ?? '${event['date']}T${event['time']}:00',
            'EndTime': event['EndTime'] ?? '${event['date']}T${event['time']}:00',
            'Capacity': event['Capacity'] ?? event['capacity'],
            'Price': event['Price'] ?? event['price'],
            'OrganizerID': event['OrganizerID'] ?? event['organizer_id'],
            'CreatedAt': event['CreatedAt'] ?? event['created_at'],
            'Status': event['Status'] ?? 'Active',
          };
        }).toList();
        
        return {
          'success': true,
          'data': convertedEvents,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch organizer events'
        };
      }
    } catch (e) {
      print('Get Events by Organizer Error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}'
      };
    }
  }

  static Future<Map<String, dynamic>> updateEvent({
    required String eventId, // Change to String for MongoDB _id
    required String title,
    required String description,
    required String category,
    required String location,
    required String date,
    required String time,
    required int capacity,
    int organizerId = 1,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/events/simple/$eventId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'category': category,
          'location': location,
          'date': date,
          'time': time,
          'capacity': capacity,
          'price': 0.0, // Default price
          'organizer_id': organizerId,
        }),
      );

      print('Update Event Response Status: ${response.statusCode}');
      print('Update Event Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final eventData = jsonDecode(response.body);
        // Convert to expected format
        final convertedEvent = {
          'EventID': eventData['id'],
          'Title': eventData['title'],
          'Description': eventData['description'],
          'Category': eventData['category'],
          'Location': eventData['location'],
          'StartTime': '${eventData['date']}T${eventData['time']}:00',
          'EndTime': '${eventData['date']}T${eventData['time']}:00',
          'Capacity': eventData['capacity'],
          'Price': eventData['price'],
          'OrganizerID': eventData['organizer_id'],
          'CreatedAt': eventData['created_at'],
        };
        
        return {
          'success': true,
          'data': convertedEvent,
          'message': 'Event updated successfully!'
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['detail'] ?? 'Failed to update event'
        };
      }
    } catch (e) {
      print('Update Event Error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}'
      };
    }
  }

  static Future<Map<String, dynamic>> deleteEvent(String eventId) async { // Change to String
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/events/simple/$eventId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Delete Event Response Status: ${response.statusCode}');
      print('Delete Event Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Event deleted successfully!'
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to delete event'
        };
      }
    } catch (e) {
      print('Delete Event Error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}'
      };
    }
  }
}
