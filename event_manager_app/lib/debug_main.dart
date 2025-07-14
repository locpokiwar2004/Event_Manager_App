import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_manager_app/presentation/cubit/event_cubit.dart';
import 'package:event_manager_app/core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await di.init();
  
  runApp(DebugApp());
}

class DebugApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Debug API Test',
      home: DebugHomePage(),
    );
  }
}

class DebugHomePage extends StatefulWidget {
  @override
  _DebugHomePageState createState() => _DebugHomePageState();
}

class _DebugHomePageState extends State<DebugHomePage> {
  late EventCubit _eventCubit;
  
  @override
  void initState() {
    super.initState();
    _eventCubit = EventCubit.create();
  }
  
  @override
  void dispose() {
    _eventCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug API Test'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              print('Button pressed: Loading hot events...');
              _eventCubit.getHotEvents(limit: 5);
            },
            child: Text('Test Hot Events API'),
          ),
          SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<EventCubit, EventState>(
              bloc: _eventCubit,
              builder: (context, state) {
                print('BlocBuilder state: $state');
                
                if (state is EventLoading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading events...'),
                      ],
                    ),
                  );
                } else if (state is EventLoaded) {
                  print('Events loaded: ${state.events.length}');
                  return ListView.builder(
                    itemCount: state.events.length,
                    itemBuilder: (context, index) {
                      final event = state.events[index];
                      return ListTile(
                        title: Text(event.title),
                        subtitle: Text('${event.category} - ${event.location}'),
                      );
                    },
                  );
                } else if (state is EventError) {
                  print('Error state: ${state.message}');
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
                            _eventCubit.getHotEvents(limit: 5);
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                
                return Center(
                  child: Text('Press button to test API'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
