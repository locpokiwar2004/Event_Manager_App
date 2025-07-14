import 'package:flutter/material.dart';
import './event_detail_page.dart';
import '../data/models/event_model.dart';

class SearchPage extends StatefulWidget {
  final List<Map<String, dynamic>> allEvents;
  
  SearchPage({required this.allEvents});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredEvents = [];
  List<Map<String, dynamic>> _allEvents = [];
  
  String _selectedCategory = 'Tất cả';
  String _selectedPriceRange = 'Tất cả';
  DateTime? _selectedDate;
  String _sortBy = 'Tên sự kiện';
  
  final List<String> _categories = [
    'Tất cả', 'Âm nhạc', 'Công nghệ', 'Ẩm thực', 
    'Nghệ thuật', 'Hài kịch', 'Mua sắm'
  ];
  
  final List<String> _priceRanges = [
    'Tất cả', 'Miễn phí', 'Dưới 1.000.000₫', 
    '1.000.000₫ - 3.000.000₫', 'Trên 3.000.000₫'
  ];
  
  final List<String> _sortOptions = [
    'Tên sự kiện', 'Ngày diễn ra', 'Giá vé (Thấp đến Cao)', 'Giá vé (Cao đến Thấp)'
  ];

  @override
  void initState() {
    super.initState();
    _allEvents = widget.allEvents;
    _filteredEvents = _allEvents;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterEvents();
  }

  void _filterEvents() {
    setState(() {
      _filteredEvents = _allEvents.where((event) {
        // Tìm kiếm theo tên
        bool matchesSearch = _searchController.text.isEmpty ||
            event['name'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
            event['venue'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
            event['organizer'].toLowerCase().contains(_searchController.text.toLowerCase());

        // Lọc theo danh mục
        bool matchesCategory = _selectedCategory == 'Tất cả' ||
            event['category'] == _selectedCategory;

        // Lọc theo khoảng giá
        bool matchesPrice = _selectedPriceRange == 'Tất cả' ||
            _checkPriceRange(event['price'], _selectedPriceRange);

        // Lọc theo ngày
        bool matchesDate = _selectedDate == null ||
            _checkDateMatch(event['date'], _selectedDate!);

        return matchesSearch && matchesCategory && matchesPrice && matchesDate;
      }).toList();

      // Sắp xếp
      _sortEvents();
    });
  }

  bool _checkPriceRange(String price, String range) {
    if (price == 'Miễn phí') {
      return range == 'Miễn phí';
    }
    
    // Chuyển đổi giá từ string sang số
    int priceValue = _parsePriceToInt(price);
    
    switch (range) {
      case 'Miễn phí':
        return price == 'Miễn phí';
      case 'Dưới 1.000.000₫':
        return priceValue < 1000000;
      case '1.000.000₫ - 3.000.000₫':
        return priceValue >= 1000000 && priceValue <= 3000000;
      case 'Trên 3.000.000₫':
        return priceValue > 3000000;
      default:
        return true;
    }
  }

  int _parsePriceToInt(String price) {
    if (price == 'Miễn phí') return 0;
    return int.tryParse(price.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
  }

  bool _checkDateMatch(String eventDate, DateTime selectedDate) {
    try {
      // Chuyển đổi format ngày từ "15 Jun 2025" sang DateTime
      List<String> dateParts = eventDate.split(' ');
      if (dateParts.length != 3) return false;
      
      int day = int.parse(dateParts[0]);
      String monthStr = dateParts[1];
      int year = int.parse(dateParts[2]);
      
      Map<String, int> monthMap = {
        'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
        'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
      };
      
      int month = monthMap[monthStr] ?? 1;
      DateTime eventDateTime = DateTime(year, month, day);
      
      return eventDateTime.year == selectedDate.year &&
             eventDateTime.month == selectedDate.month &&
             eventDateTime.day == selectedDate.day;
    } catch (e) {
      return false;
    }
  }

  void _sortEvents() {
    switch (_sortBy) {
      case 'Tên sự kiện':
        _filteredEvents.sort((a, b) => a['name'].compareTo(b['name']));
        break;
      case 'Ngày diễn ra':
        _filteredEvents.sort((a, b) => _compareDates(a['date'], b['date']));
        break;
      case 'Giá vé (Thấp đến Cao)':
        _filteredEvents.sort((a, b) => _parsePriceToInt(a['price']).compareTo(_parsePriceToInt(b['price'])));
        break;
      case 'Giá vé (Cao đến Thấp)':
        _filteredEvents.sort((a, b) => _parsePriceToInt(b['price']).compareTo(_parsePriceToInt(a['price'])));
        break;
    }
  }

  int _compareDates(String date1, String date2) {
    try {
      DateTime dt1 = _parseEventDate(date1);
      DateTime dt2 = _parseEventDate(date2);
      return dt1.compareTo(dt2);
    } catch (e) {
      return 0;
    }
  }

  DateTime _parseEventDate(String eventDate) {
    List<String> dateParts = eventDate.split(' ');
    int day = int.parse(dateParts[0]);
    String monthStr = dateParts[1];
    int year = int.parse(dateParts[2]);
    
    Map<String, int> monthMap = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
    };
    
    int month = monthMap[monthStr] ?? 1;
    return DateTime(year, month, day);
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[800],
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Bộ Lọc',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setModalState(() {
                                _selectedCategory = 'Tất cả';
                                _selectedPriceRange = 'Tất cả';
                                _selectedDate = null;
                                _sortBy = 'Tên sự kiện';
                              });
                              setState(() {});
                              _filterEvents();
                            },
                            child: Text(
                              'Đặt lại',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      
                      // Danh mục
                      Text(
                        'Danh mục',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _categories.map((category) {
                          return FilterChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (selected) {
                              setModalState(() {
                                _selectedCategory = category;
                              });
                              setState(() {});
                              _filterEvents();
                            },
                            backgroundColor: Colors.grey[700],
                            selectedColor: Colors.orange,
                            labelStyle: TextStyle(
                              color: _selectedCategory == category ? Colors.white : Colors.grey[300],
                            ),
                          );
                        }).toList(),
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Khoảng giá
                      Text(
                        'Khoảng giá',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _priceRanges.map((range) {
                          return FilterChip(
                            label: Text(range),
                            selected: _selectedPriceRange == range,
                            onSelected: (selected) {
                              setModalState(() {
                                _selectedPriceRange = range;
                              });
                              setState(() {});
                              _filterEvents();
                            },
                            backgroundColor: Colors.grey[700],
                            selectedColor: Colors.orange,
                            labelStyle: TextStyle(
                              color: _selectedPriceRange == range ? Colors.white : Colors.grey[300],
                            ),
                          );
                        }).toList(),
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Chọn ngày
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ngày diễn ra',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
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
                              if (picked != null && picked != _selectedDate) {
                                setModalState(() {
                                  _selectedDate = picked;
                                });
                                setState(() {});
                                _filterEvents();
                              }
                            },
                            child: Text(
                              _selectedDate != null 
                                ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                : 'Chọn ngày',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                      
                      if (_selectedDate != null)
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              _selectedDate = null;
                            });
                            setState(() {});
                            _filterEvents();
                          },
                          child: Text(
                            'Xóa ngày đã chọn',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      
                      SizedBox(height: 20),
                      
                      // Sắp xếp
                      Text(
                        'Sắp xếp theo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _sortBy,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          dropdownColor: Colors.grey[700],
                          style: TextStyle(color: Colors.white),
                          items: _sortOptions.map((option) {
                            return DropdownMenuItem(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setModalState(() {
                              _sortBy = value!;
                            });
                            setState(() {});
                            _filterEvents();
                          },
                        ),
                      ),
                      
                      SizedBox(height: 30),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Áp dụng',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return GestureDetector(
      onTap: () {
        // Convert Map to EventEntity using EventModel
        final eventModel = EventModel.fromJson(event);
        final eventEntity = eventModel.toEntity();
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(event: eventEntity),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
              ),
              child: Center(
                child: Icon(
                  event['image'] ?? Icons.event,
                  color: Colors.orange,
                  size: 40,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            event['category'] ?? '',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Spacer(),
                        Text(
                          event['price'] ?? '',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      event['name'] ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.grey[400], size: 14),
                        SizedBox(width: 4),
                        Text(
                          '${event['date'] ?? ''} • ${event['time'] ?? ''}',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey[400], size: 14),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event['venue'] ?? '',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
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
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm sự kiện, địa điểm, ban tổ chức...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: _showFilterBottomSheet,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.filter_list,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Active Filters Display
            if (_selectedCategory != 'Tất cả' || 
                _selectedPriceRange != 'Tất cả' || 
                _selectedDate != null)
              Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    if (_selectedCategory != 'Tất cả')
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _selectedCategory,
                              style: TextStyle(color: Colors.orange, fontSize: 12),
                            ),
                            SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategory = 'Tất cả';
                                });
                                _filterEvents();
                              },
                              child: Icon(Icons.close, color: Colors.orange, size: 16),
                            ),
                          ],
                        ),
                      ),
                    if (_selectedPriceRange != 'Tất cả')
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _selectedPriceRange,
                              style: TextStyle(color: Colors.orange, fontSize: 12),
                            ),
                            SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedPriceRange = 'Tất cả';
                                });
                                _filterEvents();
                              },
                              child: Icon(Icons.close, color: Colors.orange, size: 16),
                            ),
                          ],
                        ),
                      ),
                    if (_selectedDate != null)
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                              style: TextStyle(color: Colors.orange, fontSize: 12),
                            ),
                            SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDate = null;
                                });
                                _filterEvents();
                              },
                              child: Icon(Icons.close, color: Colors.orange, size: 16),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            
            // Results Count
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Tìm thấy ${_filteredEvents.length} sự kiện',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Sắp xếp: $_sortBy',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // Events List
            Expanded(
              child: _filteredEvents.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            color: Colors.grey[400],
                            size: 64,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Không tìm thấy sự kiện nào',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Thử thay đổi từ khóa tìm kiếm hoặc bộ lọc',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredEvents.length,
                      itemBuilder: (context, index) {
                        return _buildEventCard(_filteredEvents[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}