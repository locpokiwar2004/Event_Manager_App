import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_manager_app/presentation/cubit/event_cubit.dart';
import 'package:event_manager_app/domain/entities/event.dart';
import 'package:event_manager_app/widgets/animated_banner_widget.dart';
import './my_ticket_screen.dart';
import './account_screen.dart';
import './search_screen.dart';
import './event_detail_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late PageController _pageController;
  int _currentMonthlyIndex = 0;
  
  late List<Widget> _pages;
  late EventCubit _hotEventsCubit;
  late EventCubit _monthlyEventsCubit;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    // Initialize cubits
    _hotEventsCubit = EventCubit.create();
    _monthlyEventsCubit = EventCubit.create();
    
    _pages = [
      _buildHomeScreen(),
      MyTicketPage(),
      BlocProvider.value(
        value: _hotEventsCubit,
        child: SearchScreen(),
      ),
      AccountPage(),
    ];
    
    // Load data after UI is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hotEventsCubit.getHotEvents(limit: 10);
      _monthlyEventsCubit.getMonthlyEvents(
        year: DateTime.now().year,
        month: DateTime.now().month,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _hotEventsCubit.close();
    _monthlyEventsCubit.close();
    super.dispose();
  }

  Widget _buildHomeScreen() {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _hotEventsCubit),
        BlocProvider.value(value: _monthlyEventsCubit),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Section
            _buildBannerSection(),
            
            // Hot Events Section
            _buildHotEventsSection(),
            
            const SizedBox(height: 24),
            
            // Monthly Events Section
            _buildMonthlyEventsSection(),
            
            const SizedBox(height: 100), // Space for bottom navigation
          ],
        ),
      ),
    );
  }

  Widget _buildBannerSection() {
    final bannerItems = [
      BannerItem(
        title: 'Khám Phá Những',
        subtitle: 'Sự Kiện Tuyệt Vời',
        description: 'Tìm và đặt vé những sự kiện tốt nhất tại thành phố của bạn',
        primaryColor: const Color(0xFFFF6B35),
        secondaryColor: const Color(0xFFF7931E),
      ),
      BannerItem(
        title: 'Âm Nhạc',
        subtitle: 'Đỉnh Cao',
        description: 'Trải nghiệm những màn trình diễn âm nhạc đầy cảm xúc',
        primaryColor: const Color(0xFF667eea),
        secondaryColor: const Color(0xFF764ba2),
      ),
      BannerItem(
        title: 'Công Nghệ',
        subtitle: 'Tương Lai',
        description: 'Khám phá những đỉnh cao công nghệ và đổi mới sáng tạo',
        primaryColor: const Color(0xFF11998e),
        secondaryColor: const Color(0xFF38ef7d),
      ),
    ];

    return AnimatedBannerWidget(
      bannerItems: bannerItems,
      autoPlayDuration: const Duration(seconds: 4),
      animationDuration: const Duration(milliseconds: 800),
    );
  }

  Widget _buildHotEventsSection() {
    return Column(
      children: [
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
          height: 320,
          child: BlocBuilder<EventCubit, EventState>(
            bloc: _hotEventsCubit,
            builder: (context, state) {
              print('Hot Events State: $state');
              if (state is EventLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                );
              } else if (state is EventLoaded) {
                final events = state.events;
                print('Hot Events loaded: ${events.length} events');
                if (events.isEmpty) {
                  return const Center(
                    child: Text(
                      'Không có sự kiện hot nào',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return _buildEventCard(event, 200);
                  },
                );
              } else if (state is EventError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.grey[400],
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Lỗi tải dữ liệu',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _hotEventsCubit.getHotEvents(limit: 10);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text(
                          'Thử lại',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyEventsSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trong Tháng Này',
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
          child: BlocBuilder<EventCubit, EventState>(
            bloc: _monthlyEventsCubit,
            builder: (context, state) {
              print('Monthly Events State: $state');
              if (state is EventLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                );
              } else if (state is EventLoaded) {
                final events = state.events;
                print('Monthly Events loaded: ${events.length} events');
                if (events.isEmpty) {
                  return const Center(
                    child: Text(
                      'Không có sự kiện nào trong tháng này',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                return PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentMonthlyIndex = index;
                    });
                  },
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return _buildMonthlyEventCard(event);
                  },
                );
              } else if (state is EventError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.grey[400],
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Lỗi tải sự kiện tháng này',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          _monthlyEventsCubit.getMonthlyEvents(
                            year: DateTime.now().year,
                            month: DateTime.now().month,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text(
                          'Thử lại',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        ),
        
        // Page indicators for monthly events
        BlocBuilder<EventCubit, EventState>(
          bloc: _monthlyEventsCubit,
          builder: (context, state) {
            if (state is EventLoaded && state.events.isNotEmpty) {
              return Container(
                margin: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    state.events.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: index == _currentMonthlyIndex 
                          ? Colors.orange 
                          : Colors.orange.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ],
    );
  }

  Widget _buildEventCard(EventEntity event, double width) {
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
                child: event.img != null && event.img!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          event.img!,
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              _getCategoryIcon(event.category),
                              color: Colors.orange,
                              size: 50,
                            );
                          },
                        ),
                      )
                    : Icon(
                        _getCategoryIcon(event.category),
                        color: Colors.orange,
                        size: 50,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      event.category,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.title,
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
                        _formatDate(event.startTime),
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
                          event.location,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Sự kiện',
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
                          'Xem chi tiết',
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
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyEventCard(EventEntity event) {
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
                child: event.img != null && event.img!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                        child: Image.network(
                          event.img!,
                          width: 120,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              _getCategoryIcon(event.category),
                              color: Colors.orange,
                              size: 40,
                            );
                          },
                        ),
                      )
                    : Icon(
                        _getCategoryIcon(event.category),
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
                        event.category,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.title,
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
                            '${_formatDate(event.startTime)} • ${_formatTime(event.startTime)}',
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
                            event.location,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
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
                            'Xem chi tiết',
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

  // Helper methods
  IconData _getCategoryIcon(String category) {
    final lowerCategory = category.toLowerCase();
    switch (lowerCategory) {
      case 'music':
      case 'âm nhạc':
        return Icons.music_note;
      case 'technology':
      case 'công nghệ':
        return Icons.computer;
      case 'food':
      case 'food & drinks':
      case 'ẩm thực':
        return Icons.restaurant;
      case 'art':
      case 'nghệ thuật':
        return Icons.palette;
      case 'sport':
      case 'sports':
      case 'thể thao':
        return Icons.sports;
      case 'comedy':
      case 'hài kịch':
        return Icons.theater_comedy;
      case 'shopping':
      case 'mua sắm':
        return Icons.shopping_basket;
      default:
        return Icons.event;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--/--/----';
    try {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return '--/--/----';
    }
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '--:--';
    try {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '--:--';
    }
  }

  void _showQuickSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800],
        title: const Text(
          'Tìm kiếm nhanh',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Nhập từ khóa tìm kiếm...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: const Icon(Icons.search, color: Colors.orange),
                filled: true,
                fillColor: Colors.grey[700],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                setState(() {
                  _currentIndex = 2;
                });
                // Pass search query to search screen if needed
              },
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'Âm nhạc', 'Công nghệ', 'Ẩm thực', 'Nghệ thuật', 'Thể thao'
              ].map((category) => GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _currentIndex = 2;
                  });
                  // Pass category filter to search screen if needed
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentIndex = 2;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text(
              'Tìm kiếm',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
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
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              _showQuickSearchDialog();
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
