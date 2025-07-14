# Event Manager App - Data Layer Documentation

## Architecture Overview

This Flutter app follows Clean Architecture principles with three main layers:

1. **Presentation Layer** - UI components, BLoC/Cubit state management
2. **Domain Layer** - Business logic, entities, use cases, repository interfaces
3. **Data Layer** - Data sources, repository implementations, models

## Event Management Features

### Available Use Cases

#### 1. Get All Events
```dart
final eventCubit = EventCubit.create();
await eventCubit.getAllEvents();
```

#### 2. Get Hot Events
```dart
final eventCubit = EventCubit.create();
await eventCubit.getHotEvents(limit: 10);
```

#### 3. Get Upcoming Events
```dart
final eventCubit = EventCubit.create();
await eventCubit.getUpcomingEvents(limit: 5);
```

#### 4. Search Events
```dart
final eventCubit = EventCubit.create();
await eventCubit.searchEvents(
  query: "music",
  category: "entertainment",
  location: "Ho Chi Minh City",
  dateFrom: DateTime.now(),
  dateTo: DateTime.now().add(Duration(days: 30)),
  minPrice: 0.0,
  maxPrice: 100.0,
  limit: 20,
  offset: 0,
);
```

### Backend API Integration

The app integrates with the FastAPI backend running on `http://localhost:8000/`. All API endpoints are properly configured:

- **GET** `/api/v1/events/` - Get all events
- **GET** `/api/v1/events/hot` - Get hot events  
- **GET** `/api/v1/events/upcoming` - Get upcoming events
- **GET** `/api/v1/events/monthly` - Get monthly events
- **GET** `/api/v1/events/search` - Search events
- **GET** `/api/v1/events/{id}` - Get event by ID
- **GET** `/api/v1/events/{id}/with-organizer` - Get event with organizer info
- **PATCH** `/api/v1/events/{id}/status` - Update event status
- **POST** `/api/v1/events/bulk-publish` - Bulk publish events

### Using the Event Cubit in Widgets

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_manager_app/presentation/cubit/event_cubit.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EventCubit.create()..getAllEvents(),
      child: BlocBuilder<EventCubit, EventState>(
        builder: (context, state) {
          if (state is EventLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is EventLoaded) {
            return ListView.builder(
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                final event = state.events[index];
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text(event.description),
                  trailing: Text('\$${event.ticketPrice?.toStringAsFixed(2) ?? 'Free'}'),
                );
              },
            );
          } else if (state is EventError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Center(child: Text('No events available'));
        },
      ),
    );
  }
}
```

### Error Handling

The app handles various types of errors:

- **NetworkFailure** - Network connectivity issues
- **ServerFailure** - Backend server errors  
- **AuthFailure** - Authentication problems
- **NotFoundFailure** - Resource not found (404)
- **ValidationFailure** - Input validation errors
- **UnknownFailure** - Unexpected errors

### Dependencies

Make sure your `pubspec.yaml` includes:

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  dio: ^5.3.2
  get_it: ^7.6.4
  dartz: ^0.10.1
  intl: ^0.18.0
```

### Setup Instructions

1. Ensure the FastAPI backend is running on `http://localhost:8000/`
2. The dependency injection is automatically initialized in `main.dart`
3. Use `EventCubit.create()` to get a properly configured cubit instance
4. Wrap your widgets with `BlocProvider` and `BlocBuilder` for state management

### Next Steps

To extend the event management functionality:

1. **Add Create/Update Events** - Implement forms to create and edit events
2. **Event Details Page** - Create detailed view for individual events
3. **Offline Support** - Add local caching with Hive or SQLite
4. **Image Upload** - Integrate image picker and upload functionality
5. **Push Notifications** - Add event reminders and updates

This data layer provides a solid foundation for building a complete event management application with proper separation of concerns and testable architecture.
