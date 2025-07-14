import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_manager_app/presentation/cubit/event_cubit.dart';
import 'package:event_manager_app/domain/entities/event.dart';

class EventTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Events API'),
        backgroundColor: Colors.orange,
      ),
      body: BlocProvider(
        create: (_) => EventCubit.create()..getHotEvents(limit: 5),
        child: BlocBuilder<EventCubit, EventState>(
          builder: (context, state) {
            if (state is EventLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.orange),
                    SizedBox(height: 16),
                    Text('Loading events...')
                  ],
                ),
              );
            } else if (state is EventLoaded) {
              return ListView.builder(
                itemCount: state.events.length,
                itemBuilder: (context, index) {
                  final event = state.events[index];
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(event.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Category: ${event.category}'),
                          Text('Location: ${event.location}'),
                          Text('Date: ${event.startTime}'),
                          Text('Event ID: ${event.eventId}'),
                        ],
                      ),
                      leading: Icon(Icons.event, color: Colors.orange),
                    ),
                  );
                },
              );
            } else if (state is EventError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text('Error: ${state.message}'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<EventCubit>().getHotEvents(limit: 5);
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return Center(child: Text('Unknown state'));
          },
        ),
      ),
    );
  }
}
