import 'package:flutter/material.dart';
import 'package:event_manager_app/domain/usecases/get_hot_events.dart';
import 'package:event_manager_app/domain/usecases/ticket_use_cases.dart';
import 'package:event_manager_app/core/di/injection_container.dart';
import 'package:event_manager_app/domain/entities/event.dart';
import 'package:event_manager_app/screens/event_detail_page.dart';

class ApiDebugPage extends StatefulWidget {
  @override
  _ApiDebugPageState createState() => _ApiDebugPageState();
}

class _ApiDebugPageState extends State<ApiDebugPage> {
  String _result = 'Chưa test API';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Debug Test'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'API Test Result:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
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
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _testHotEventsAPI,
              child: _loading 
                ? CircularProgressIndicator(color: Colors.white)
                : Text('Test Hot Events API'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _testTicketAPI,
              child: _loading 
                ? CircularProgressIndicator(color: Colors.white)
                : Text('Test Ticket API (Event ID 1)'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _navigateToEventDetail(context),
              child: Text('Go to Event ID 1 (Food Truck Festival)'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testHotEventsAPI() async {
    setState(() {
      _loading = true;
      _result = 'Testing API...';
    });

    try {
      // Get use case from DI
      final getHotEventsUseCase = sl<GetHotEventsUseCase>();
      
      // Call API
      final result = await getHotEventsUseCase(GetHotEventsParams(limit: 5));
      
      result.fold(
        (failure) {
          setState(() {
            _result = 'ERROR: ${failure.message}';
            _loading = false;
          });
        },
        (events) {
          setState(() {
            _result = 'SUCCESS: Found ${events.length} events\n\n' +
                events.map((e) => '${e.title} - ${e.category}').join('\n');
            _loading = false;
          });
        },
      );
    } catch (error) {
      setState(() {
        _result = 'EXCEPTION: $error';
        _loading = false;
      });
    }
  }

  Future<void> _testTicketAPI() async {
    setState(() {
      _loading = true;
      _result = 'Testing Ticket API...';
    });

    try {
      // Get ticket use case from DI
      final getEventTickets = sl<GetEventTickets>();
      
      // Call API for Event ID 1
      final result = await getEventTickets(1);
      
      result.fold(
        (failure) {
          setState(() {
            _result = 'TICKET API ERROR: ${failure}';
            _loading = false;
          });
        },
        (tickets) {
          setState(() {
            _result = 'TICKET API SUCCESS: Found ${tickets.length} tickets for Event ID 1\n\n' +
                tickets.map((t) => '${t.name} - \$${t.price} (Max: ${t.onePer})').join('\n');
            _loading = false;
          });
        },
      );
    } catch (error) {
      setState(() {
        _result = 'TICKET API EXCEPTION: $error';
        _loading = false;
      });
    }
  }

  void _navigateToEventDetail(BuildContext context) {
    // Create a sample Event entity for Event ID 1 (Food Truck Festival)
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
