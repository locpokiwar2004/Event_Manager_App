import 'package:flutter/material.dart';
import 'package:event_manager_app/core/services/event_service.dart';

class EditEventScreen extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const EditEventScreen({
    Key? key,
    required this.eventData,
  }) : super(key: key);

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedCategory = 'Technology';
  List<Map<String, dynamic>> _tickets = [];
  bool _isLoading = false;

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
  void initState() {
    super.initState();
    _initializeData();
    _loadEventTickets();
  }

  void _initializeData() {
    _titleController.text = widget.eventData['Title'] ?? '';
    _descriptionController.text = widget.eventData['Description'] ?? '';
    _locationController.text = widget.eventData['Location'] ?? '';
    _capacityController.text = (widget.eventData['Capacity'] ?? 0).toString();
    _selectedCategory = widget.eventData['Category'] ?? 'Technology';

    // Parse date and time from StartTime
    final startTime = DateTime.parse(widget.eventData['StartTime']);
    _selectedDate = startTime;
    _selectedTime = TimeOfDay.fromDateTime(startTime);
  }

  Future<void> _loadEventTickets() async {
    try {
      final eventId = widget.eventData['EventID'] ?? widget.eventData['_id'];
      final result = await EventService.getEventTickets(eventId.toString());
      
      if (result['success']) {
        setState(() {
          _tickets = List<Map<String, dynamic>>.from(result['data']);
        });
      }
    } catch (e) {
      print('Error loading tickets: $e');
    }
  }

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
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Color(0xFF2A2A2A),
        title: Text(
          'Edit Event',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveEvent,
            child: Text(
              'Save',
              style: TextStyle(
                color: _isLoading ? Colors.grey : Colors.orange,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.orange))
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Details Section
                    _buildSectionHeader('Event Details'),
                    SizedBox(height: 16),
                    
                    _buildInputField(
                      label: 'Event Title',
                      controller: _titleController,
                      hintText: 'Enter event title',
                      validator: (value) => value?.isEmpty == true ? 'Please enter event title' : null,
                    ),
                    SizedBox(height: 16),

                    _buildInputField(
                      label: 'Description',
                      controller: _descriptionController,
                      hintText: 'Describe your event',
                      maxLines: 4,
                      validator: (value) => value?.isEmpty == true ? 'Please enter event description' : null,
                    ),
                    SizedBox(height: 16),

                    _buildDropdownField(
                      label: 'Category',
                      value: _selectedCategory,
                      items: _categories,
                      onChanged: (value) => setState(() => _selectedCategory = value!),
                    ),
                    SizedBox(height: 16),

                    _buildInputField(
                      label: 'Location',
                      controller: _locationController,
                      hintText: 'Event location',
                      validator: (value) => value?.isEmpty == true ? 'Please enter event location' : null,
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(child: _buildDateField()),
                        SizedBox(width: 12),
                        Expanded(child: _buildTimeField()),
                      ],
                    ),
                    SizedBox(height: 16),

                    _buildInputField(
                      label: 'Capacity',
                      controller: _capacityController,
                      hintText: 'Max attendees',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty == true) return 'Enter capacity';
                        if (int.tryParse(value!) == null) return 'Enter valid number';
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 32),

                    // Tickets Section
                    _buildSectionHeader('Event Tickets'),
                    SizedBox(height: 16),
                    
                    ..._tickets.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> ticket = entry.value;
                      return _buildTicketCard(ticket, index);
                    }).toList(),
                    
                    SizedBox(height: 16),
                    _buildAddTicketButton(),
                    
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
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
            decoration: InputDecoration(border: InputBorder.none),
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

  Widget _buildTicketCard(Map<String, dynamic> ticket, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ticket ${index + 1}',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue, size: 20),
                    onPressed: () => _editTicket(ticket, index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () => _deleteTicket(ticket, index),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            ticket['Name'] ?? 'Unnamed Ticket',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTicketInfo('Price', '${ticket['Price']} VND'),
              _buildTicketInfo('Max per person', '${ticket['OnePer']}'),
              _buildTicketInfo('Total', '${ticket['QuantityTotal']}'),
              _buildTicketInfo('Sold', '${ticket['QuantitySold'] ?? 0}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTicketInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAddTicketButton() {
    return Container(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _addNewTicket,
        icon: Icon(Icons.add, color: Colors.orange),
        label: Text(
          'Add New Ticket',
          style: TextStyle(color: Colors.orange),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.orange),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
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
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
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
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _editTicket(Map<String, dynamic> ticket, int index) {
    _showTicketDialog(ticket: ticket, index: index);
  }

  void _addNewTicket() {
    _showTicketDialog();
  }

  void _deleteTicket(Map<String, dynamic> ticket, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800],
        title: Text('Delete Ticket', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete "${ticket['Name']}"?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performDeleteTicket(ticket, index);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _performDeleteTicket(Map<String, dynamic> ticket, int index) async {
    try {
      if (ticket.containsKey('TicketID')) {
        // Delete from server
        final result = await EventService.deleteTicket(ticket['TicketID'].toString());
        if (result['success']) {
          setState(() {
            _tickets.removeAt(index);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ticket deleted successfully'), backgroundColor: Colors.green),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
          );
        }
      } else {
        // Remove from local list (new ticket not yet saved)
        setState(() {
          _tickets.removeAt(index);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showTicketDialog({Map<String, dynamic>? ticket, int? index}) {
    final nameController = TextEditingController(text: ticket?['Name'] ?? '');
    final priceController = TextEditingController(text: (ticket?['Price'] ?? 0).toString());
    final onePerController = TextEditingController(text: (ticket?['OnePer'] ?? 1).toString());
    final totalController = TextEditingController(text: (ticket?['QuantityTotal'] ?? 0).toString());
    final soldController = TextEditingController(text: (ticket?['QuantitySold'] ?? 0).toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800],
        title: Text(
          ticket == null ? 'Add New Ticket' : 'Edit Ticket',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogField('Ticket Name', nameController),
              SizedBox(height: 12),
              _buildDialogField('Price (VND)', priceController, keyboardType: TextInputType.number),
              SizedBox(height: 12),
              _buildDialogField('Max per person', onePerController, keyboardType: TextInputType.number),
              SizedBox(height: 12),
              _buildDialogField('Total quantity', totalController, keyboardType: TextInputType.number),
              SizedBox(height: 12),
              _buildDialogField('Sold quantity', soldController, keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final newTicket = {
                'Name': nameController.text,
                'Price': double.tryParse(priceController.text) ?? 0.0,
                'OnePer': int.tryParse(onePerController.text) ?? 1,
                'QuantityTotal': int.tryParse(totalController.text) ?? 0,
                'QuantitySold': int.tryParse(soldController.text) ?? 0,
              };

              if (ticket != null && ticket.containsKey('TicketID')) {
                newTicket['TicketID'] = ticket['TicketID'];
              }

              if (index != null) {
                setState(() {
                  _tickets[index] = newTicket;
                });
              } else {
                setState(() {
                  _tickets.add(newTicket);
                });
              }

              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[700],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select date and time'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final eventId = widget.eventData['EventID'] ?? widget.eventData['_id'];
      
      // Prepare update data
      final updateData = {
        'Title': _titleController.text.trim(),
        'Description': _descriptionController.text.trim(),
        'Category': _selectedCategory,
        'Location': _locationController.text.trim(),
        'StartTime': DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        ).toIso8601String(),
        'EndTime': DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour + 2, // Default 2 hours duration
          _selectedTime!.minute,
        ).toIso8601String(),
        'Capacity': int.parse(_capacityController.text.trim()),
        'tickets': _tickets,
      };

      final result = await EventService.updateEventWithTickets(eventId.toString(), updateData);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event updated successfully'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
