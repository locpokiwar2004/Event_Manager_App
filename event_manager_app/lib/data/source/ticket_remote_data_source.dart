import 'package:dio/dio.dart';
import 'package:event_manager_app/data/models/ticket_model.dart';

abstract class TicketRemoteDataSource {
  Future<List<TicketModel>> getEventTickets(int eventId);
  Future<TicketModel> createTicket(TicketModel ticket);
  Future<List<TicketModel>> getAllTickets();
}

class TicketRemoteDataSourceImpl implements TicketRemoteDataSource {
  final Dio dio;

  TicketRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<TicketModel>> getEventTickets(int eventId) async {
    try {
      print('Fetching tickets for event ID: $eventId');
      final response = await dio.get('/api/v1/events/$eventId/tickets');
      
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      
      if (response.data is List) {
        return (response.data as List)
            .map((ticket) => TicketModel.fromJson(ticket))
            .toList();
      } else {
        throw Exception('Expected List but got ${response.data.runtimeType}');
      }
    } catch (e) {
      print('Error fetching event tickets: $e');
      if (e is DioException) {
        print('DioException details: ${e.response?.data}');
      }
      throw Exception('Failed to fetch event tickets: $e');
    }
  }

  @override
  Future<TicketModel> createTicket(TicketModel ticket) async {
    try {
      print('Creating ticket: ${ticket.toJson()}');
      final response = await dio.post('/api/v1/tickets/', data: ticket.toJson());
      
      print('Create ticket response: ${response.data}');
      
      return TicketModel.fromJson(response.data);
    } catch (e) {
      print('Error creating ticket: $e');
      if (e is DioException) {
        print('DioException details: ${e.response?.data}');
      }
      throw Exception('Failed to create ticket: $e');
    }
  }

  @override
  Future<List<TicketModel>> getAllTickets() async {
    try {
      print('Fetching all tickets');
      final response = await dio.get('/api/v1/tickets/');
      
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      
      if (response.data is List) {
        return (response.data as List)
            .map((ticket) => TicketModel.fromJson(ticket))
            .toList();
      } else {
        throw Exception('Expected List but got ${response.data.runtimeType}');
      }
    } catch (e) {
      print('Error fetching all tickets: $e');
      if (e is DioException) {
        print('DioException details: ${e.response?.data}');
      }
      throw Exception('Failed to fetch all tickets: $e');
    }
  }
}
