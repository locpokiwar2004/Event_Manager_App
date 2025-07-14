import 'package:flutter/material.dart';
import 'package:event_manager_app/core/services/ticket_service.dart';

class CreateTicketsScreen extends StatefulWidget {
  final Map<String, dynamic> eventData;
  
  const CreateTicketsScreen({Key? key, required this.eventData}) : super(key: key);

  @override
  _CreateTicketsScreenState createState() => _CreateTicketsScreenState();
}

class _CreateTicketsScreenState extends State<CreateTicketsScreen> {
  List<TicketFormData> _tickets = [];
  bool _isCreatingTickets = false;

  @override
  void initState() {
    super.initState();
    // Add default ticket
    _addTicket();
  }

  void _addTicket() {
    setState(() {
      _tickets.add(TicketFormData());
    });
  }

  void _removeTicket(int index) {
    if (_tickets.length > 1) {
      setState(() {
        _tickets.removeAt(index);
      });
    }
  }

  Future<void> _createAllTickets() async {
    // Validate all tickets
    for (int i = 0; i < _tickets.length; i++) {
      if (!_tickets[i].isValid()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill all fields for Ticket ${i + 1}'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    setState(() {
      _isCreatingTickets = true;
    });

    try {
      int successCount = 0;
      int totalTickets = _tickets.length;

      for (int i = 0; i < _tickets.length; i++) {
        final ticket = _tickets[i];
        final result = await TicketService.createTicket(
          eventId: widget.eventData['EventID'],
          name: ticket.nameController.text.trim(),
          price: int.parse(ticket.priceController.text.trim()).toDouble(),
          onePer: int.parse(ticket.onePerController.text.trim()),
          quantityTotal: int.parse(ticket.quantityController.text.trim()),
        );

        if (result['success']) {
          successCount++;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create ${ticket.nameController.text}: ${result['message']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }

      setState(() {
        _isCreatingTickets = false;
      });

      if (successCount == totalTickets) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('All $totalTickets tickets created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Return success result to CreateEventTab
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Created $successCount/$totalTickets tickets'),
            backgroundColor: Colors.orange,
          ),
        );
        // Return partial success
        Navigator.of(context).pop(successCount > 0);
      }
    } catch (e) {
      setState(() {
        _isCreatingTickets = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating tickets: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Color(0xFF2A2A2A),
        title: Text(
          'Create Tickets',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Event Info Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event: ${widget.eventData['Title']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Event ID: ${widget.eventData['EventID']}',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Capacity: ${widget.eventData['Capacity']} people',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Tickets List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: _tickets.length,
                itemBuilder: (context, index) {
                  return _buildTicketForm(index);
                },
              ),
            ),

            // Bottom Actions
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Add Ticket Button
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 12),
                    child: OutlinedButton.icon(
                      onPressed: _addTicket,
                      icon: Icon(Icons.add, color: Colors.orange),
                      label: Text(
                        'Add Another Ticket Type',
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
                  ),

                  // Create All Tickets Button
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isCreatingTickets ? null : _createAllTickets,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isCreatingTickets
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Creating Tickets...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              'Create All Tickets (${_tickets.length})',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketForm(int index) {
    final ticket = _tickets[index];
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ticket Type ${index + 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_tickets.length > 1)
                IconButton(
                  onPressed: () => _removeTicket(index),
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
            ],
          ),
          SizedBox(height: 16),

          // Ticket Name
          _buildInputField(
            label: 'Ticket Name',
            controller: ticket.nameController,
            hintText: 'e.g., Early Bird, VIP, General',
          ),
          SizedBox(height: 16),

          // Price and OnePer
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: 'Price (VND)',
                  controller: ticket.priceController,
                  hintText: '0',
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildInputField(
                  label: 'Max per Person',
                  controller: ticket.onePerController,
                  hintText: '1',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Quantity
          _buildInputField(
            label: 'Total Quantity',
            controller: ticket.quantityController,
            hintText: 'Number of tickets available',
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500]),
            filled: true,
            fillColor: Colors.grey[700],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.orange, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class TicketFormData {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController onePerController = TextEditingController(text: '1');
  final TextEditingController quantityController = TextEditingController();

  bool isValid() {
    return nameController.text.trim().isNotEmpty &&
           priceController.text.trim().isNotEmpty &&
           onePerController.text.trim().isNotEmpty &&
           quantityController.text.trim().isNotEmpty &&
           int.tryParse(priceController.text.trim()) != null &&
           int.tryParse(onePerController.text.trim()) != null &&
           int.tryParse(quantityController.text.trim()) != null;
  }

  void dispose() {
    nameController.dispose();
    priceController.dispose();
    onePerController.dispose();
    quantityController.dispose();
  }
}
