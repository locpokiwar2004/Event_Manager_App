import 'dart:convert';
import 'package:http/http.dart' as http;

class TicketService {
  static const String baseUrl = 'http://localhost:8000/api/v1';
  
  static Future<Map<String, dynamic>> createTicket({
    required int eventId,
    required String name,
    required double price,
    required int onePer,
    required int quantityTotal,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tickets/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'EventID': eventId,
          'Name': name,
          'Price': price,
          'OnePer': onePer,
          'QuantityTotal': quantityTotal,
        }),
      );

      print('Create Ticket Response Status: ${response.statusCode}');
      print('Create Ticket Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
          'message': 'Ticket created successfully!'
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['detail'] ?? 'Failed to create ticket'
        };
      }
    } catch (e) {
      print('Create Ticket Error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}'
      };
    }
  }

  static Future<Map<String, dynamic>> getTicketsByEventId(int eventId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tickets/event/$eventId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Get Tickets Response Status: ${response.statusCode}');
      print('Get Tickets Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch tickets'
        };
      }
    } catch (e) {
      print('Get Tickets Error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}'
      };
    }
  }
}
