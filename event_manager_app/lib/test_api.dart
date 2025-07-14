import 'package:dio/dio.dart';

void main() async {
  print('Testing API connectivity...');
  
  try {
    final dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:8000/',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      responseType: ResponseType.json,
      sendTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10)
    ));
    
    print('Making request to: http://localhost:8000/api/v1/events/hot');
    
    final response = await dio.get('api/v1/events/hot');
    
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
    
    if (response.data is List) {
      print('Number of events: ${response.data.length}');
      for (var event in response.data) {
        print('Event: ${event['Title']} - ${event['Category']}');
      }
    }
    
  } catch (e) {
    print('Error: $e');
    if (e is DioException) {
      print('DioException type: ${e.type}');
      print('DioException message: ${e.message}');
      print('DioException response: ${e.response}');
    }
  }
}
