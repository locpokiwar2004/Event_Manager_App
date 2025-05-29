import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Để quản lý trạng thái của BottomNavigationBar
  int _selectedCategoryIndex = -1; // -1 means no category is selected initially

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Triển khai logic điều hướng ở đây dựa trên chỉ mục
    // For example:
    // if (index == 0) { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage())); }
    // else if (index == 1) { Navigator.push(context, MaterialPageRoute(builder: (context) => WorldPage())); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF001C44), // Darker blue at top
              Color(0xFF0C5776), // Lighter teal/blue at bottom
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          // Đảm bảo toàn bộ nội dung có thể cuộn
          child: Column(
            children: [
              // Header Section (Vị trí và Tìm kiếm)
              _buildHeaderSection(),
              // Main Content (Thể loại và Sự kiện nổi bật)
              _buildMainContent(),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar - Thanh điều hướng phía dưới
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            const Color(0xFF001C44), // Màu nền của thanh điều hướng
        selectedItemColor: Colors.white, // Màu biểu tượng được chọn
        unselectedItemColor: Colors.white54, // Màu biểu tượng không được chọn
        type: BottomNavigationBarType.fixed, // Giữ nguyên màu nền khi item được chọn
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '', // Không có label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.language),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined), // Biểu tượng dấu cộng
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }

  // Widget riêng cho phần Header
  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa nội dung cột
        children: [
          // Hello and Location - Căn giữa
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Căn giữa chữ Hello và TP. Hồ Chí Minh
            children: const [
              Text(
                'Hello',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Căn giữa icon và text TP. Hồ Chí Minh
                children: [
                  Icon(Icons.location_on, color: Colors.white, size: 20),
                  SizedBox(width: 5),
                  Text(
                    'TP. Hồ Chí Minh',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Search Bar - Thanh tim kiem
          GestureDetector(
            onTap: () {
              Navigator.push(
                context, //nut dieu huong
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white, // Màu nền của thanh tìm kiếm
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: const TextField(
                enabled: false, // Vô hiệu hóa bàn phím nhưng vẫn hiển thị text
                style: TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'What tickets are you looking for?',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget riêng cho phần Main Content (Categories và Hot Events)
  Widget _buildMainContent() {
    // Định nghĩa danh sách các danh mục để dễ dàng quản lý
    final List<Map<String, dynamic>> categories = [
      {'icon': Icons.headset, 'label': 'Music'},
      {'icon': Icons.nights_stay, 'label': 'Nightlife'},
      {'icon': Icons.sentiment_satisfied_alt, 'label': 'Performing'},
      {'icon': Icons.wb_sunny, 'label': 'Holidays'},
      {'icon': Icons.chat_bubble_outline, 'label': 'Dating'},
      {'icon': Icons.sports_basketball, 'label': 'Hobbies'},
      {'icon': Icons.business_center, 'label': 'Business'},
      {'icon': Icons.local_cafe, 'label': 'Food'},
      {'icon': Icons.all_out, 'label': 'Workshop'},
    ];

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFEBF3FF), // Nền trắng cho phần này
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories Grid
            GridView.builder(
              shrinkWrap: true, // Quan trọng để GridView không chiếm hết chiều cao
              physics: const NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn riêng của GridView
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 cột
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return _buildCategoryItem(
                  context,
                  category['icon'],
                  category['label'],
                  index, // Truyền index để xác định mục nào được chọn
                );
              },
            ),
            const SizedBox(height: 30),
            // Thay thế mục "HOT" bằng mẫu mới
            _buildHotEventsSection(context), // Truyền context vào đây
            const SizedBox(height:
                20), // Khoảng trống cuối cùng để cuộn lên trên thanh bottom nav
          ],
        ),
      ),
    );
  }

  // Widget riêng cho từng mục danh mục
  Widget _buildCategoryItem(
      BuildContext context, IconData icon, String label, int index) {
    // Kiểm tra xem mục hiện tại có được chọn hay không
    final bool isSelected = _selectedCategoryIndex == index;

    // Định nghĩa màu sắc dựa trên trạng thái được chọn
    final Color itemBackgroundColor =
        isSelected ? const Color(0xFF001C44) :  Colors.white; // Đổi màu nền
    final Color itemIconColor =
        isSelected ? Colors.white : const Color(0xFF001C44); // Đổi màu icon
    final Color itemTextColor =
        isSelected ? Colors.white : Colors.black87; // Đổi màu chữ

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index; // Cập nhật mục được chọn
        });
        // Bạn có thể giữ hoặc xóa SnackBar tùy ý
        /*
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have clicked $label')),
        );
        */
      },
      child: Container(
        decoration: BoxDecoration(
          color: itemBackgroundColor, // Sử dụng màu nền động
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: itemIconColor), // Sử dụng màu icon động
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: itemTextColor, // Sử dụng màu chữ động
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget mới cho phần "Hot Events" với tiêu đề và "View All"
  Widget _buildHotEventsSection(BuildContext context) {
    // Giả sử bạn có một danh sách các URL hình ảnh cho sự kiện
    final List<String> hotEventImages = [
      'https://img.evbuc.com/https%3A%2F%2Fcdn.evbuc.com%2Fimages%2F831772729%2F1520517282543%2F1%2Foriginal.20240821-200359?w=940&auto=format%2Ccompress&q=75&sharp=10&rect=0%2C0%2C2160%2C1080&s=7e8ece39cd8a9738520656b333f4441c',
      'https://img.evbuc.com/https%3A%2F%2Fcdn.evbuc.com%2Fimages%2F918001103%2F2548598761081%2F1%2Foriginal.20241216-074549?crop=focalpoint&fit=crop&w=940&auto=format%2Ccompress&q=75&sharp=10&fp-x=0.5&fp-y=0.5&s=1956fb0f20afb094090e304ae9c7eab9',
      'https://img.evbuc.com/https%3A%2F%2Fcdn.evbuc.com%2Fimages%2F968745963%2F124277772125%2F1%2Foriginal.20250225-101856?w=940&auto=format%2Ccompress&q=75&sharp=10&s=acdcc2446f9c7426a3434a6a58d8026e',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0), // Có thể điều chỉnh padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'HOT',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Điều hướng đến trang xem tất cả các sự kiện HOT
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('See all HOT events')),
                  );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => HotEventsAllPage()),
                  // );
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFF2C99AE), // Màu tương đồng với màu gradient
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        // Thay đổi từ ListView.builder ngang sang dọc
        ListView.builder(
          shrinkWrap: true, // Quan trọng để ListView không chiếm hết chiều cao
          physics: const NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn riêng của ListView
          itemCount: hotEventImages.length, // Số lượng sự kiện hot demo (2 sự kiện như ảnh mẫu)
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15.0), // Khoảng cách giữa các thẻ
              //Truyen URL hinh anh vao the
              child: _buildHotEventCard(index,hotEventImages[index]),
            );
          },
        ),
      ],
    );
  }

  // Widget riêng cho từng thẻ sự kiện Hot theo mẫu mới
  Widget _buildHotEventCard(int index, String imageUrl) {
    return GestureDetector(
      onTap: () {
        /*
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have clicked on the Hot event ${index + 1}')),
        );
        */
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => EventDetailPage(eventId: index)),
        // );
      },
      child: Container(
        height: 200, // Chiều cao cố định cho thẻ
        decoration: BoxDecoration(
          color: const Color(0xFFF0F5FA), // Màu nền của thẻ (màu trắng nhạt)
          borderRadius: BorderRadius.circular(20), // Bo tròn góc thẻ
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              // Phần trên của thẻ (nội dung chính)
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Màu nền trắng cho phần trên
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                
                //child: Center(
                  // Bạn có thể thêm nội dung ảnh hoặc text ở đây
                  // Ví dụ:
                  // child: Text(
                  //   'Event Content ${index + 1}',
                  //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  // ),
                //),
              ),
              ),
        ),
            ),
            // Phần dưới của thẻ (thanh màu đậm và nút mũi tên)
            Container(
              height: 60, // Chiều cao của thanh dưới
              decoration: const BoxDecoration(
                color: Color(0xFF001C44), // Màu xanh đậm
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Nút màu trắng
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward, color: Color(0xFF001C44)),
                      onPressed: () {
                        /*
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Điều hướng sự kiện Hot ${index + 1}')),
                        );
                        */
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => EventDetailPage(eventId: index)),
                        // );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Trang tìm kiếm mẫu
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF001C44), // Darker blue at top
              Color(0xFF2C99AE), // Lighter teal/blue at bottom
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section (Back button, Location, Search bar)
              _buildSearchHeader(context),
              // Content below the header (Recent Searches and Search Suggestions)
              _buildSearchContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 20.0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context); // Quay lại trang trước
                },
              ),
              const Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: Colors.white, size: 20),
                    SizedBox(width: 5),
                    Text(
                      'TP. Hồ Chí Minh',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48), // Dùng để cân bằng khoảng cách cho nút back
            ],
          ),
          const SizedBox(height: 20),
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white54),
            ),
            child: const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: Colors.white70),
                hintText: 'Events', // Chữ 'Events' trong thanh tìm kiếm
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchContent(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white, // Nền trắng cho phần này
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recent Searches (Events summer)
            const Text(
              'Recent searches',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6, // Số lượng mục Events summer
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey, // Màu đường kẻ dưới
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Text(
                      'Events summer ${index + 1}',
                      style: TextStyle(
                        color: Colors.blue.shade700, // Màu xanh như hình
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            // Search Suggestions
            const Text(
              'Search suggestions',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 cột
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.8, // Tỷ lệ chiều rộng/chiều cao của mỗi item
              ),
              itemCount: 4, // Số lượng gợi ý tìm kiếm
              itemBuilder: (context, index) {
                return _buildSearchSuggestionCard(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSuggestionCard(int index) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FA), // Màu nền của thẻ gợi ý
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade100, width: 1.5), // Border màu xanh nhạt
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 150, // Chiều cao của vùng ảnh
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200, // Màu nền cho placeholder ảnh
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: const Center(
              child: Text(
                'imagel', // Chữ "imagel" như trong ảnh
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'GoiYI', // Chữ "GoiYI" như trong ảnh
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}