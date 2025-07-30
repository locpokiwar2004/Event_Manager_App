import 'package:dio/dio.dart';
import 'package:event_manager_app/core/constants/api_url.dart';
import 'package:event_manager_app/core/network/dio_client.dart';
import 'package:event_manager_app/data/models/event_model.dart';
import 'package:event_manager_app/data/source/event_remote_data_source.dart';

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final DioClient dioClient;

  EventRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<EventModel>> getEvents() async {
    try {
      final response = await dioClient.get(ApiUrl.events);
      final List<dynamic> data = response.data;
      return data.map((json) => EventModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<EventModel> getEventById(int id) async {
    try {
      final response = await dioClient.get(ApiUrl.eventById(id));
      return EventModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<EventWithOrganizerModel> getEventWithOrganizer(int id) async {
    try {
      final response = await dioClient.get(ApiUrl.eventWithOrganizer(id));
      return EventWithOrganizerModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<EventModel>> getHotEvents({int? limit}) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (limit != null) queryParams['limit'] = limit;
      
      final response = await dioClient.get(
        ApiUrl.hotEvents,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      final List<dynamic> data = response.data;
      return data.map((json) => EventModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<EventModel>> getUpcomingEvents({int? limit}) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (limit != null) queryParams['limit'] = limit;
      
      final response = await dioClient.get(
        ApiUrl.upcomingEvents,
        queryParameters: queryParams,
      );
      final List<dynamic> data = response.data;
      return data.map((json) => EventModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<EventModel>> getMonthlyEvents({
    required int year,
    required int month,
  }) async {
    try {
      final response = await dioClient.get(
        ApiUrl.monthlyEvents,
        queryParameters: {
          'year': year,
          'month': month,
        },
      );
      final List<dynamic> data = response.data;
      return data.map((json) => EventModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
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
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      
      if (query != null && query.isNotEmpty) queryParams['query'] = query;
      if (category != null && category.isNotEmpty) queryParams['category'] = category;
      if (location != null && location.isNotEmpty) queryParams['location'] = location;
      if (dateFrom != null) {
        queryParams['date_from'] = dateFrom.toIso8601String().split('T')[0]; // YYYY-MM-DD format
      }
      if (dateTo != null) {
        queryParams['date_to'] = dateTo.toIso8601String().split('T')[0]; // YYYY-MM-DD format
      }
      if (minPrice != null) queryParams['min_price'] = minPrice;
      if (maxPrice != null) queryParams['max_price'] = maxPrice;
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;
      
      final response = await dioClient.get(
        ApiUrl.searchEvents,
        queryParameters: queryParams,
      );
      final List<dynamic> data = response.data;
      return data.map((json) => EventModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<EventModel>> getEventsByOrganizer(int organizerId) async {
    try {
      final response = await dioClient.get(ApiUrl.eventsByOrganizer(organizerId));
      final List<dynamic> data = response.data;
      return data.map((json) => EventModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<EventModel> createEvent(EventModel event) async {
    try {
      final response = await dioClient.post(
        ApiUrl.events,
        data: event.toJson(),
      );
      return EventModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<EventModel> updateEvent(EventModel event) async {
    try {
      final response = await dioClient.put(
        ApiUrl.eventById(event.eventId),
        data: event.toJson(),
      );
      return EventModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteEvent(int id) async {
    try {
      await dioClient.delete(ApiUrl.eventById(id));
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<EventModel> updateEventStatus(int id, String status) async {
    try {
      final response = await dioClient.patch(
        ApiUrl.eventStatus(id),
        data: {'status': status},
      );
      return EventModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<EventModel>> bulkPublishEvents(List<int> eventIds) async {
    try {
      final response = await dioClient.post(
        ApiUrl.bulkPublishEvents,
        data: {'event_ids': eventIds},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => EventModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('Connection timeout');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data?['message'] ?? 'Server error';
          return Exception('Server error ($statusCode): $message');
        case DioExceptionType.cancel:
          return Exception('Request cancelled');
        case DioExceptionType.connectionError:
          return Exception('Network connection error');
        default:
          return Exception('Unknown network error: ${error.message}');
      }
    }
    return Exception('Unknown error: $error');
  }
}
