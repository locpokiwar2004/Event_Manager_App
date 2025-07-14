import 'package:flutter/material.dart';
import 'package:event_manager_app/data/models/event_model.dart';
import 'package:event_manager_app/core/network/dio_client.dart';
import 'package:event_manager_app/core/constants/api_url.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('Testing complete data flow...');
  
  try {
    // Test DioClient
    final dioClient = DioClient();
    
    print('Making request to: ${ApiUrl.hotEvents}');
    final response = await dioClient.get(ApiUrl.hotEvents);
    
    print('Response status: ${response.statusCode}');
    print('Response data type: ${response.data.runtimeType}');
    
    if (response.data is List) {
      final List<dynamic> data = response.data;
      print('Number of raw events: ${data.length}');
      
      // Test EventModel parsing
      final events = data.map((json) {
        print('Parsing event: ${json['Title']}');
        return EventModel.fromJson(json);
      }).toList();
      
      print('Successfully parsed ${events.length} events:');
      for (var event in events) {
        print('- ${event.title} (${event.category}) at ${event.location}');
      }
    }
    
  } catch (e) {
    print('Error: $e');
  }
}
