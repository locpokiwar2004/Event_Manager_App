import 'package:flutter/material.dart';
import 'package:event_manager_app/core/services/event_service.dart';
import 'package:event_manager_app/core/services/auth_service.dart';
import 'package:event_manager_app/screens/organizer/create_tickets_screen.dart';

class OrganizerDashboard extends StatefulWidget {
  @override
  _OrganizerDashboardState createState() => _OrganizerDashboardState();
}

class _OrganizerDashboardState extends State<OrganizerDashboard> {
  int _selectedIndex = 0;
  Map<String, String?> _userData = {};
  int _currentUserId = 1; // Default fallback

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await AuthService.getUserData();
      setState(() {
        _userData = userData;
        // Convert userId string to int, fallback to 1 if null or invalid
        _currentUserId = int.tryParse(userData['userId'] ?? '') ?? 1;
        
        // If no user data, set demo data for testing
        if (_userData['name'] == null || _userData['name']!.isEmpty) {
          _userData = {
            'name': 'Demo Organizer',
            'email': 'demo@organizer.com',
            'userId': '1',
            'token': 'demo_token',
          };
          _currentUserId = 1;
        }
      });
    } catch (e) {
      print('Error loading user data: $e');
      // Set demo data as fallback
      setState(() {
        _userData = {
          'name': 'Demo Organizer',
          'email': 'demo@organizer.com',
          'userId': '1',
          'token': 'demo_token',
        };
        _currentUserId = 1;
      });
    }
  }

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          OrganizerHomeTab(
            onTabChanged: _changeTab,
            userData: _userData,
            userId: _currentUserId,
          ),
          CreateEventTab(
            userId: _currentUserId,
            onTabChanged: _changeTab,
          ),
          ManageEventsTab(userId: _currentUserId),
          OrganizerProfileTab(userData: _userData),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF2A2A2A),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey[400],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Create Event',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'My Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Organizer Home Tab
class OrganizerHomeTab extends StatefulWidget {
  final Function(int)? onTabChanged;
  final Map<String, String?> userData;
  final int userId;
  
  const OrganizerHomeTab({
    this.onTabChanged,
    required this.userData,
    required this.userId,
  });
  
  @override
  _OrganizerHomeTabState createState() => _OrganizerHomeTabState();
}

class _OrganizerHomeTabState extends State<OrganizerHomeTab> {
  List<Map<String, dynamic>> _recentEvents = [];
  Map<String, int> _stats = {
    'totalEvents': 0,
    'activeEvents': 0,
    'totalAttendees': 0,
    'revenue': 0,
  };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load events for current organizer
      final result = await EventService.getEventsByOrganizer(widget.userId);
      if (result['success']) {
        final events = List<Map<String, dynamic>>.from(result['data']);
        
        // Calculate stats
        int totalEvents = events.length;
        int activeEvents = 0;
        int totalAttendees = 0;
        
        for (var event in events) {
          DateTime startTime = DateTime.parse(event['StartTime'] ?? DateTime.now().toIso8601String());
          DateTime endTime = DateTime.parse(event['EndTime'] ?? DateTime.now().toIso8601String());
          DateTime now = DateTime.now();
          
          // Check if event is active (happening soon or ongoing)
          if (endTime.isAfter(now)) {
            activeEvents++;
          }
          
          // Add to total attendees (placeholder - would need actual attendance data)
          totalAttendees += (event['Capacity'] as int? ?? 0) ~/ 4; // Assume 25% attendance for demo
        }
        
        setState(() {
          _recentEvents = events.take(3).toList(); // Show only 3 recent events
          _stats = {
            'totalEvents': totalEvents,
            'activeEvents': activeEvents,
            'totalAttendees': totalAttendees,
            'revenue': totalEvents * 50000, // Demo revenue calculation (50k VND per event)
          };
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading dashboard data: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(color: Colors.orange),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back, ${widget.userData['name'] ?? 'Organizer'}!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.userData['email'] ?? 'organizer@email.com',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.orange,
                    size: 28,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Total Events',
                    value: '${_stats['totalEvents']}',
                    icon: Icons.event,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: 'Active Events',
                    value: '${_stats['activeEvents']}',
                    icon: Icons.event_available,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Total Attendees',
                    value: '${_stats['totalAttendees']}',
                    icon: Icons.people,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: 'Revenue',
                    value: '${(_stats['revenue']! / 1000).toInt()}K VND',
                    icon: Icons.attach_money,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Quick Actions
            Text(
              'Quick Actions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    title: 'Create Event',
                    icon: Icons.add_circle,
                    color: Colors.orange,
                    onTap: () {
                      // Switch to create event tab
                      if (widget.onTabChanged != null) {
                        widget.onTabChanged!(1);
                      }
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    title: 'View Analytics',
                    icon: Icons.analytics,
                    color: Colors.blue,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Recent Events
            Text(
              'Recent Events',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ..._recentEvents.map((event) {
              DateTime startTime = DateTime.parse(event['StartTime'] ?? DateTime.now().toIso8601String());
              DateTime endTime = DateTime.parse(event['EndTime'] ?? DateTime.now().toIso8601String());
              DateTime now = DateTime.now();
              
              String status;
              if (endTime.isBefore(now)) {
                status = 'Completed';
              } else if (startTime.difference(now).inDays <= 7 && startTime.isAfter(now)) {
                status = 'Active';
              } else {
                status = 'Upcoming';
              }
              
              return Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: _buildRecentEventCard(
                  title: event['Title'] ?? 'Untitled Event',
                  date: '${startTime.day}/${startTime.month}/${startTime.year}',
                  attendees: '${(event['Capacity'] as int? ?? 0) ~/ 4}', // Demo attendance
                  status: status,
                ),
              );
            }).toList(),
            if (_recentEvents.isEmpty)
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_busy,
                        color: Colors.grey[600],
                        size: 48,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No events yet',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Create your first event to get started',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentEventCard({
    required String title,
    required String date,
    required String attendees,
    required String status,
  }) {
    Color statusColor = status == 'Active' ? Colors.green : Colors.orange;
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.event,
              color: Colors.orange,
              size: 28,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
                Text(
                  '$attendees attendees',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Create Event Tab
class CreateEventTab extends StatefulWidget {
  final int userId;
  final Function(int)? onTabChanged;
  
  const CreateEventTab({
    required this.userId,
    this.onTabChanged,
  });
  
  @override
  _CreateEventTabState createState() => _CreateEventTabState();
}

class _CreateEventTabState extends State<CreateEventTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedCategory = 'Technology';
  
  final List<String> _categories = [
    'Technology',
    'Business',
    'Entertainment',
    'Sports',
    'Education',
    'Health',
    'Art & Culture',
    'Music',
    'Food & Drink',
    'Other'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Create New Event',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Fill in the details to create your event',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 24),

              // Event Title
              _buildInputField(
                label: 'Event Title',
                controller: _titleController,
                hintText: 'Enter event title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Event Description
              _buildInputField(
                label: 'Description',
                controller: _descriptionController,
                hintText: 'Describe your event',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Category Dropdown
              _buildDropdownField(
                label: 'Category',
                value: _selectedCategory,
                items: _categories,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              SizedBox(height: 16),

              // Location
              _buildInputField(
                label: 'Location',
                controller: _locationController,
                hintText: 'Event location or online',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Date and Time
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildTimeField(),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Capacity
              _buildInputField(
                label: 'Capacity',
                controller: _capacityController,
                hintText: 'Max attendees',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter capacity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Enter valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),

              // Create Event Button
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _createEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Continue to Create Tickets',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500]),
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.orange, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            dropdownColor: Colors.grey[800],
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            items: items.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.orange),
                SizedBox(width: 12),
                Text(
                  _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'Select date',
                  style: TextStyle(
                    color: _selectedDate != null ? Colors.white : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: _selectTime,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: Colors.orange),
                SizedBox(width: 12),
                Text(
                  _selectedTime != null
                      ? '${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                      : 'Select time',
                  style: TextStyle(
                    color: _selectedTime != null ? Colors.white : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.orange,
              onPrimary: Colors.white,
              surface: Colors.grey[800]!,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.orange,
              onPrimary: Colors.white,
              surface: Colors.grey[800]!,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _createEvent() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select event date'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      if (_selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select event time'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[800],
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.orange),
                SizedBox(width: 16),
                Text(
                  'Creating event...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        },
      );

      try {
        // Format date and time
        String formattedDate = '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
        String formattedTime = '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';

        // Call API to create event
        final result = await EventService.createEvent(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _selectedCategory,
          location: _locationController.text.trim(),
          date: formattedDate,
          time: formattedTime,
          capacity: int.parse(_capacityController.text.trim()),
          price: 0.0, // Default price, will be set by tickets
          organizerId: widget.userId, // Use actual user ID
        );

        // Close loading dialog
        Navigator.of(context).pop();

        if (result['success']) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to create tickets screen
          final ticketsResult = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTicketsScreen(
                eventData: result['data'],
              ),
            ),
          );

          // After tickets are created, navigate to My Events tab
          if (ticketsResult == true || ticketsResult == null) {
            // Clear form
            _titleController.clear();
            _descriptionController.clear();
            _locationController.clear();
            _capacityController.clear();
            setState(() {
              _selectedDate = null;
              _selectedTime = null;
              _selectedCategory = 'Technology';
            });
            
            // Navigate to My Events tab (index 2)
            if (widget.onTabChanged != null) {
              widget.onTabChanged!(2);
            }
          }
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Close loading dialog
        Navigator.of(context).pop();
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating event: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// Manage Events Tab
class ManageEventsTab extends StatefulWidget {
  final int userId;
  
  const ManageEventsTab({required this.userId});
  
  @override
  _ManageEventsTabState createState() => _ManageEventsTabState();
}

class _ManageEventsTabState extends State<ManageEventsTab> {
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get events for current organizer
      final result = await EventService.getEventsByOrganizer(widget.userId);
      if (result['success']) {
        setState(() {
          _events = List<Map<String, dynamic>>.from(result['data']);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading events: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Events',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Manage your created events',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _loadEvents,
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.orange,
                    size: 28,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    )
                  : _events.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_busy,
                                color: Colors.grey[600],
                                size: 64,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No events created yet',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Create your first event to get started',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          color: Colors.orange,
                          backgroundColor: Colors.grey[800],
                          onRefresh: _loadEvents,
                          child: ListView.builder(
                            itemCount: _events.length,
                            itemBuilder: (context, index) {
                              return _buildEventCard(_events[index]);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    // Parse datetime from API response
    DateTime startTime = DateTime.parse(event['StartTime'] ?? DateTime.now().toIso8601String());
    DateTime endTime = DateTime.parse(event['EndTime'] ?? DateTime.now().toIso8601String());
    DateTime now = DateTime.now();
    
    String status;
    Color statusColor;
    
    if (endTime.isBefore(now)) {
      status = 'Completed';
      statusColor = Colors.grey;
    } else if (startTime.difference(now).inDays <= 7 && startTime.isAfter(now)) {
      status = 'Active';
      statusColor = Colors.green;
    } else {
      status = 'Upcoming';
      statusColor = Colors.orange;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  event['Title'] ?? 'Untitled Event',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '${startTime.day}/${startTime.month}/${startTime.year} at ${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          Text(
            event['Location'] ?? 'Location TBD',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildStatChip(
                Icons.people,
                '0/${event['Capacity']}',
                Colors.blue,
              ),
              SizedBox(width: 12),
              _buildStatChip(
                Icons.category,
                event['Category'] ?? 'General',
                Colors.purple,
              ),
              SizedBox(width: 12),
              _buildStatChip(
                Icons.schedule,
                '${endTime.difference(startTime).inHours}h',
                Colors.orange,
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _showEventDetails(event);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.orange),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'View Details',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _editEvent(event);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _deleteEvent(event);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showEventDetails(Map<String, dynamic> event) {
    DateTime startTime = DateTime.parse(event['StartTime'] ?? DateTime.now().toIso8601String());
    DateTime endTime = DateTime.parse(event['EndTime'] ?? DateTime.now().toIso8601String());
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: Text(
            event['Title'] ?? 'Event Details',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Description', event['Description'] ?? 'No description'),
                _buildDetailRow('Category', event['Category'] ?? 'General'),
                _buildDetailRow('Location', event['Location'] ?? 'TBD'),
                _buildDetailRow('Start Time', '${startTime.day}/${startTime.month}/${startTime.year} at ${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}'),
                _buildDetailRow('End Time', '${endTime.day}/${endTime.month}/${endTime.year} at ${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}'),
                _buildDetailRow('Capacity', '${event['Capacity']} people'),
                _buildDetailRow('Event ID', '${event['EventID']}'),
                _buildDetailRow('Status', '${event['Status']}'),
                _buildDetailRow('Created', DateTime.parse(event['CreatedAt']).toString().split('.')[0]),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.orange,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _editEvent(Map<String, dynamic> event) {
    _showEditEventDialog(event);
  }

  void _deleteEvent(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: Text(
            'Delete Event',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete "${event['Title']}"?\nThis action cannot be undone.',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _performDeleteEvent(event['_id'] ?? event['EventID'].toString());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performDeleteEvent(String eventId) async {
    try {
      final result = await EventService.deleteEvent(eventId);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: result['success'] ? Colors.green : Colors.red,
        ),
      );

      if (result['success']) {
        _loadEvents(); // Reload events list
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting event: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showEditEventDialog(Map<String, dynamic> event) {
    final _editFormKey = GlobalKey<FormState>();
    final _editTitleController = TextEditingController(text: event['Title']);
    final _editDescriptionController = TextEditingController(text: event['Description']);
    final _editLocationController = TextEditingController(text: event['Location']);
    final _editCapacityController = TextEditingController(text: event['Capacity'].toString());
    
    String _editSelectedCategory = event['Category'] ?? 'Technology';
    DateTime _editSelectedDate = DateTime.parse(event['StartTime']);
    TimeOfDay _editSelectedTime = TimeOfDay.fromDateTime(_editSelectedDate);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.grey[800],
              title: Text(
                'Edit Event',
                style: TextStyle(color: Colors.white),
              ),
              content: Container(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Form(
                    key: _editFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        TextFormField(
                          controller: _editTitleController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Event Title',
                            labelStyle: TextStyle(color: Colors.orange),
                            filled: true,
                            fillColor: Colors.grey[700],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter event title';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        
                        // Description
                        TextFormField(
                          controller: _editDescriptionController,
                          maxLines: 3,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(color: Colors.orange),
                            filled: true,
                            fillColor: Colors.grey[700],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        
                        // Location
                        TextFormField(
                          controller: _editLocationController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Location',
                            labelStyle: TextStyle(color: Colors.orange),
                            filled: true,
                            fillColor: Colors.grey[700],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter location';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        
                        // Capacity
                        TextFormField(
                          controller: _editCapacityController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Capacity',
                            labelStyle: TextStyle(color: Colors.orange),
                            filled: true,
                            fillColor: Colors.grey[700],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter capacity';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter valid number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_editFormKey.currentState!.validate()) {
                      Navigator.of(context).pop();
                      await _performUpdateEvent(
                        event['_id'] ?? event['EventID'].toString(),
                        _editTitleController.text.trim(),
                        _editDescriptionController.text.trim(),
                        _editSelectedCategory,
                        _editLocationController.text.trim(),
                        _editSelectedDate,
                        _editSelectedTime,
                        int.parse(_editCapacityController.text.trim()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _performUpdateEvent(
    String eventId,
    String title,
    String description,
    String category,
    String location,
    DateTime date,
    TimeOfDay time,
    int capacity,
  ) async {
    try {
      String formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      String formattedTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

      final result = await EventService.updateEvent(
        eventId: eventId,
        title: title,
        description: description,
        category: category,
        location: location,
        date: formattedDate,
        time: formattedTime,
        capacity: capacity,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: result['success'] ? Colors.green : Colors.red,
        ),
      );

      if (result['success']) {
        _loadEvents(); // Reload events list
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating event: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// Organizer Profile Tab
class OrganizerProfileTab extends StatelessWidget {
  final Map<String, String?> userData;
  
  const OrganizerProfileTab({required this.userData});
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Organizer Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Colors.orange,
                    size: 28,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Profile Info
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.orange,
                    child: Icon(
                      Icons.business_center,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    userData['name'] ?? 'Event Organizer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    userData['email'] ?? 'organizer@eventmanager.com',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),

            // Settings Menu
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.edit,
                    title: 'Edit Profile',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.notifications,
                    title: 'Notification Settings',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.analytics,
                    title: 'Analytics & Reports',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.payment,
                    title: 'Payment Settings',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.help,
                    title: 'Help & Support',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Switch back to attendee
            Container(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.orange),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Switch to Attendee Mode',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.orange,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey[400],
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[700],
      height: 1,
      indent: 56,
    );
  }
}
