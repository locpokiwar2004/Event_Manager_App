import 'package:flutter/material.dart';

class MyTicketPage extends StatelessWidget {
  final List<Map<String, dynamic>> myTickets = [
    {
      '_id': '671f4b7a1234567890abcdf0',
      'title': 'Hội thảo Công nghệ 2025',
      'category': 'Công nghệ',
      'description': 'Sự kiện về AI và Blockchain',
      'start_time': '2025-06-01T09:00:00.000+00:00',
      'end_time': '2025-06-01T17:00:00.000+00:00',
      'location': {
        'name': 'Trung tâm Hội nghị Quốc gia',
        'address': 'Số 57 Phạm Hùng, Hà Nội'
      },
      'ticket_type': {
        'type': 'VIP',
        'price': 1000000,
      },
      'status': 'upcoming',
      'image_url': 'https://example.com/event.jpg',
      'qr_code': 'VIP-123456',
      'seat_number': 'A-12',
      'gate_number': 'Cổng 1',
    },
    {
      '_id': '671f4b7a1234567890abcdf1',
      'title': 'Triển lãm Công nghệ Tương lai',
      'category': 'Công nghệ',
      'description': 'Trải nghiệm các công nghệ mới nhất',
      'start_time': '2025-06-15T08:00:00.000+00:00',
      'end_time': '2025-06-17T20:00:00.000+00:00',
      'location': {
        'name': 'Trung tâm Triển lãm Sài Gòn',
        'address': '799 Nguyễn Văn Linh, Quận 7, TP.HCM'
      },
      'ticket_type': {
        'type': 'Regular',
        'price': 500000,
      },
      'status': 'active',
      'image_url': 'https://example.com/event2.jpg',
      'qr_code': 'REG-789012',
      'seat_number': 'B-45',
      'gate_number': 'Cổng chính',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vé của tôi', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[900],
      body: myTickets.isEmpty
          ? _buildEmptyState()
          : _buildTicketList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.confirmation_number_outlined,
              size: 60,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Bạn chưa có vé nào',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Các vé bạn đã đặt sẽ hiển thị tại đây',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'Xem sự kiện',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: myTickets.length,
      itemBuilder: (context, index) {
        final ticket = myTickets[index];
        return _buildTicketCard(ticket);
      },
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    final dateTime = DateTime.parse(ticket['start_time']);
    final formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    final formattedTime = '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    final price = ticket['ticket_type']['price'];
    final formattedPrice = '${price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )} VNĐ';

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.grey[800]!,
            Colors.grey[850]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main ticket content
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        ticket['category'],
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: ticket['status'] == 'active'
                            ? Colors.green
                            : Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        ticket['status'] == 'active' ? 'Đang hoạt động' : 'Sắp diễn ra',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 16),
                
                // Event name and price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        ticket['title'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      formattedPrice,
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 16),
                
                // Event details
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          Icons.calendar_today,
                          'Ngày & Giờ',
                          '$formattedDate lúc $formattedTime',
                        ),
                        SizedBox(height: 8),
                        _buildDetailRow(
                          Icons.location_on,
                          'Địa điểm',
                          ticket['location']['name'],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          Icons.confirmation_number,
                          'Loại vé',
                          ticket['ticket_type']['type'],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
          
          // Dotted divider
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: List.generate(
                20,
                (index) => Expanded(
                  child: Container(
                    height: 2,
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // QR code section
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hiển thị mã QR tại lối vào',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.qr_code,
                            color: Colors.orange,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Mã vé: ${ticket['qr_code']}',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showQRCode(ticket),
                  icon: Icon(Icons.qr_code_scanner, size: 18),
                  label: Text('Xem QR'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.orange,
          size: 16,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
          ),
        ),
      ],
    );
  }

  void _showQRCode(Map<String, dynamic> ticket) {
    // Implement QR code display
    print('Showing QR code for ticket: ${ticket['qr_code']}');
  }
}