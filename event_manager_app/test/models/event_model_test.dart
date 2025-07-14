import 'package:flutter_test/flutter_test.dart';
import 'package:event_manager_app/data/models/event.dart';

void main() {
  group('Event Model Tests', () {
    final testJson = {
      'EventID': 1,
      'Title': 'Test Event',
      'Description': 'This is a test event',
      'Category': 'Technology',
      'Location': 'Ho Chi Minh City',
      'Img': 'https://example.com/image.jpg',
      'StartTime': '2024-12-30T10:00:00Z',
      'EndTime': '2024-12-30T18:00:00Z',
      'Capacity': 100,
      'OrganizerID': 1,
      'Status': 'published',
      'CreatedAt': '2024-12-29T10:00:00Z',
      'UpdatedAt': '2024-12-29T10:00:00Z',
      'Organizer': {
        'UserID': 1,
        'FullName': 'John Doe',
        'Email': 'john@example.com',
        'Phone': '0123456789',
        'Address': 'Ho Chi Minh City'
      }
    };

    test('Event should parse from JSON correctly', () {
      final event = Event.fromJson(testJson);
      
      expect(event.eventId, equals(1));
      expect(event.title, equals('Test Event'));
      expect(event.description, equals('This is a test event'));
      expect(event.category, equals('Technology'));
      expect(event.location, equals('Ho Chi Minh City'));
      expect(event.img, equals('https://example.com/image.jpg'));
      expect(event.capacity, equals(100));
      expect(event.organizerId, equals(1));
      expect(event.status, equals(EventStatus.published));
      expect(event.organizer, isNotNull);
      expect(event.organizer!.fullName, equals('John Doe'));
    });

    test('Event should convert to JSON correctly', () {
      final event = Event(
        eventId: 1,
        title: 'Test Event',
        description: 'This is a test event',
        category: 'Technology',
        location: 'Ho Chi Minh City',
        startTime: DateTime.parse('2024-12-30T10:00:00Z'),
        endTime: DateTime.parse('2024-12-30T18:00:00Z'),
        capacity: 100,
        organizerId: 1,
        status: EventStatus.published,
      );

      final json = event.toJson();
      
      expect(json['EventID'], equals(1));
      expect(json['Title'], equals('Test Event'));
      expect(json['Status'], equals('published'));
      expect(json['Capacity'], equals(100));
    });

    test('Event helper methods should work correctly', () {
      final event = Event(
        eventId: 1,
        title: 'Test Event',
        description: 'This is a test event',
        category: 'Technology',
        location: 'Ho Chi Minh City',
        startTime: DateTime(2024, 12, 30, 10, 0),
        endTime: DateTime(2024, 12, 30, 18, 0),
        capacity: 100,
        organizerId: 1,
        status: EventStatus.published,
      );

      expect(event.formattedStartDate, equals('30/12/2024'));
      expect(event.formattedStartTime, equals('10:00'));
      expect(event.formattedDuration, equals('8 hour(s)'));
      expect(event.duration.inHours, equals(8));
    });

    test('EventStatus extension should work correctly', () {
      expect(EventStatusExtension.fromString('draft'), equals(EventStatus.draft));
      expect(EventStatusExtension.fromString('published'), equals(EventStatus.published));
      expect(EventStatusExtension.fromString('cancelled'), equals(EventStatus.cancelled));
      expect(EventStatusExtension.fromString('invalid'), equals(EventStatus.draft));
      
      expect(EventStatus.draft.value, equals('draft'));
      expect(EventStatus.published.value, equals('published'));
      expect(EventStatus.cancelled.value, equals('cancelled'));
    });

    test('EventCreateRequest should work correctly', () {
      final request = EventCreateRequest(
        title: 'New Event',
        description: 'Description',
        category: 'Technology',
        location: 'HCM City',
        startTime: DateTime(2024, 12, 30, 10, 0),
        endTime: DateTime(2024, 12, 30, 18, 0),
        capacity: 100,
        organizerId: 1,
      );

      final json = request.toJson();
      expect(json['Title'], equals('New Event'));
      expect(json['Capacity'], equals(100));
      expect(json['OrganizerID'], equals(1));
    });

    test('EventListResponse should handle empty lists', () {
      final response = EventListResponse.fromList([]);
      expect(response.events, isEmpty);
      expect(response.totalCount, isNull);
    });

    test('EventListResponse should parse event lists correctly', () {
      final eventList = [testJson];
      final response = EventListResponse.fromList(eventList);
      
      expect(response.events, hasLength(1));
      expect(response.events.first.title, equals('Test Event'));
    });
  });
}
