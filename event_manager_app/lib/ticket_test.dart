import 'package:flutter/material.dart';
import 'package:event_manager_app/domain/entities/event.dart';
import 'package:event_manager_app/screens/event_detail_page.dart';
import 'package:event_manager_app/core/network/dio_client.dart';
import 'package:event_manager_app/server_locator.dart';

class TicketTestPage extends StatefulWidget {
  @override
  _TicketTestPageState createState() => _TicketTestPageState();
}

class _TicketTestPageState extends State<TicketTestPage> {
  String _result = 'Chưa test API';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Test'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _result,
                style: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _testDirectAPI,
              child: _loading 
                ? CircularProgressIndicator()
                : Text('Test Direct API Call'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _goToEventDetail(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: Text('Test Event ID 1 (Food Truck Festival)'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testDirectAPI() async {
    setState(() {
      _loading = true;
      _result = 'Testing direct API call...';
    });

    try {
      final dioClient = sl<DioClient>();
      print('Testing direct API call to /api/v1/events/1/tickets');
      
      final response = await dioClient.get('/api/v1/events/1/tickets');
      
      setState(() {
        _result = 'SUCCESS: Status ${response.statusCode}\nData: ${response.data}';
        _loading = false;
      });
      
    } catch (e) {
      print('Direct API error: $e');
      setState(() {
        _result = 'ERROR: $e';
        _loading = false;
      });
    }
  }

  void _goToEventDetail(BuildContext context) {
    // Create Event ID 1 (Food Truck Festival)
    final eventEntity = EventEntity(
      eventId: 1,
      title: 'Food Truck Festival',
      description: 'Experience delicious food from various food trucks and enjoy live music.',
      category: 'Ẩm thực',
      location: 'Central Park',
      img: null,
      startTime: DateTime.now().add(Duration(days: 30)),
      endTime: DateTime.now().add(Duration(days: 30, hours: 6)),
      capacity: 1000,
      organizerId: 1,
      status: 'published',
      createdAt: DateTime.now().subtract(Duration(days: 10)),
      updatedAt: DateTime.now().subtract(Duration(days: 1)),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPage(event: eventEntity),
      ),
    );
  }
}
