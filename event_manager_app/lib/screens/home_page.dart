import 'package:flutter/material.dart';
import './my_ticket_screen.dart';
import './account_screen.dart';
import './search_page.dart';
import './event_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;
  int _currentBannerIndex = 0;
  int _currentWeekendIndex = 0;
  
  final List<Map<String, dynamic>> hotEvents = [
    {
      'id': '1',
      'name': 'Lễ Hội Âm Nhạc Mùa Hè',
      'date': '15 Jun 2025',
      'time': '18:00',
      'venue': 'Công Viên Trung Tâm',
      'price': '2.100.000₫',
      'category': 'Âm nhạc',
      'image': Icons.music_note,
      'description': 'Lễ hội âm nhạc lớn nhất mùa hè với sự tham gia của các nghệ sĩ hàng đầu',
      'organizer': 'Công ty Tổ chức Sự kiện ABC',
      'organizerContact': '0901234567',
      'organizerEmail': 'contact@abc-events.com',
      'ticketTypes': [
        {'type': 'Thường', 'price': '1.500.000₫'},
        {'type': 'VIP', 'price': '2.100.000₫'},
        {'type': 'SVIP', 'price': '3.500.000₫'},
      ],
    },
    {
      'id': '2',
      'name': 'Hội Nghị Công Nghệ 2025',
      'date': '22 Jun 2025',
      'time': '09:00',
      'venue': 'Trung Tâm Hội Nghị',
      'price': '4.800.000₫',
      'category': 'Công nghệ',
      'image': Icons.computer,
      'description': 'Hội nghị công nghệ thường niên với những xu hướng mới nhất',
      'organizer': 'Tech Vietnam',
      'organizerContact': '0912345678',
      'organizerEmail': 'info@techvn.com',
      'ticketTypes': [
        {'type': 'Sinh viên', 'price': '2.500.000₫'},
        {'type': 'Thường', 'price': '4.800.000₫'},
        {'type': 'Doanh nghiệp', 'price': '8.500.000₫'},
      ],
    },
    {
      'id': '3',
      'name': 'Triển Lãm Ẩm Thực & Rượu Vang',
      'date': '28 Jun 2025',
      'time': '12:00',
      'venue': 'Nhà Triển Lãm',
      'price': '1.080.000₫',
      'category': 'Ẩm thực',
      'image': Icons.restaurant,
      'description': 'Khám phá những món ăn tinh tế và rượu vang cao cấp từ khắp thế giới',
      'organizer': 'Saigon Food Festival',
      'organizerContact': '0923456789',
      'organizerEmail': 'hello@saigonfood.vn',
      'ticketTypes': [
        {'type': 'Thường', 'price': '1.080.000₫'},
        {'type': 'Premium', 'price': '2.200.000₫'},
      ],
    },
    {
      'id': '4',
      'name': 'Khai Mạc Triển Lãm Nghệ Thuật',
      'date': '30 Jun 2025',
      'time': '19:00',
      'venue': 'Bảo Tàng Nghệ Thuật Hiện Đại',
      'price': '600.000₫',
      'category': 'Nghệ thuật',
      'image': Icons.palette,
      'description': 'Triển lãm nghệ thuật đương đại với tác phẩm của các họa sĩ nổi tiếng',
      'organizer': 'Nhà Triển Lãm Nghệ Thuật HCM',
      'organizerContact': '0934567890',
      'organizerEmail': 'art@hcmgallery.vn',
      'ticketTypes': [
        {'type': 'Thường', 'price': '600.000₫'},
        {'type': 'VIP', 'price': '1.200.000₫'},
      ],
    },
  ];

  final List<Map<String, dynamic>> weekendEvents = [
    {
      'id': '5',
      'name': 'Đêm Hài Kịch Thứ Bảy',
      'date': '14 Jun 2025',
      'time': '20:00',
      'venue': 'Câu Lạc Bộ Hài Kịch',
      'price': '840.000₫',
      'category': 'Hài kịch',
      'image': Icons.theater_comedy,
      'description': 'Đêm diễn hài kịch vui nhộn với các diễn viên nổi tiếng',
      'organizer': 'Comedy Club Saigon',
      'organizerContact': '0945678901',
      'organizerEmail': 'booking@comedysaigon.com',
      'ticketTypes': [
        {'type': 'Thường', 'price': '840.000₫'},
        {'type': 'VIP', 'price': '1.500.000₫'},
      ],
    },
    {
      'id': '6',
      'name': 'Lễ Hội Brunch Chủ Nhật',
      'date': '15 Jun 2025',
      'time': '11:00',
      'venue': 'Quảng Trường Thành Phố',
      'price': '600.000₫',
      'category': 'Ẩm thực',
      'image': Icons.brunch_dining,
      'description': 'Tiệc brunch ngoài trời với nhiều món ăn đặc sắc',
      'organizer': 'Sunday Brunch Festival',
      'organizerContact': '0956789012',
      'organizerEmail': 'info@sundaybrunch.vn',
      'ticketTypes': [
        {'type': 'Thường', 'price': '600.000₫'},
        {'type': 'Premium', 'price': '1.200.000₫'},
      ],
    },
    {
      'id': '7',
      'name': 'Chợ Cuối Tuần',
      'date': '16 Jun 2025',
      'time': '08:00',
      'venue': 'Chợ Địa Phương',
      'price': 'Miễn phí',
      'category': 'Mua sắm',
      'image': Icons.shopping_basket,
      'description': 'Chợ cuối tuần với nhiều sản phẩm thủ công và địa phương',
      'organizer': 'Hiệp Hội Chợ Cuối Tuần',
      'organizerContact': '0967890123',
      'organizerEmail': 'market@weekend.vn',
      'ticketTypes': [
        {'type': 'Miễn phí', 'price': 'Miễn phí'},
      ],
    },
  ];

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pages = [
      _buildHomePage(),
      MyTicketPage(),
      SearchPage(allEvents: [...hotEvents, ...weekendEvents]),
      AccountPage(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Section
          Container(
            height: 200,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Khám Phá Những',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Sự Kiện Tuyệt Vời',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Tìm và đặt vé những sự kiện tốt nhất tại thành phố của bạn',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: index == _currentBannerIndex 
                            ? Colors.white 
                            : Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          
          // Hot Events Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sự Kiện Hot',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 2; // Navigate to search page
                    });
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Xem tất cả',
                        style: TextStyle(color: Colors.orange),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.orange,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: hotEvents.length,
              itemBuilder: (context, index) {
                final event = hotEvents[index];
                return _buildEventCard(event, 200);
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          // This Weekend Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cuối Tuần Này',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 2; // Navigate to search page
                    });
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Xem tất cả',
                        style: TextStyle(color: Colors.orange),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.orange,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentWeekendIndex = index;
                });
              },
              itemCount: weekendEvents.length,
              itemBuilder: (context, index) {
                final event = weekendEvents[index];
                return _buildWeekendEventCard(event);
              },
            ),
          ),
          
          // Page indicators for weekend events
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                weekendEvents.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: index == _currentWeekendIndex 
                      ? Colors.orange 
                      : Colors.orange.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 100), // Space for bottom navigation
        ],
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event, double width) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(event: event),
          ),
        );
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: Icon(
                  event['image'] as IconData,
                  color: Colors.orange,
                  size: 50,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        event['category'] as String,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event['name'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.grey[400], size: 14),
                        const SizedBox(width: 4),
                        Text(
                          event['date'] as String,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey[400], size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event['venue'] as String,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            event['price'] as String,
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Đặt vé',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildWeekendEventCard(Map<String, dynamic> event) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(event: event),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 120,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              ),
              child: Center(
                child: Icon(
                  event['image'] as IconData,
                  color: Colors.orange,
                  size: 40,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        event['category'] as String,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event['name'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.grey[400], size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${event['date']} • ${event['time']}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            event['price'] as String,
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Đặt vé',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: const Text(
          'Festrix',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                _currentIndex = 2;
              });
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.grey[850],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'Vé của tôi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Tìm kiếm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}