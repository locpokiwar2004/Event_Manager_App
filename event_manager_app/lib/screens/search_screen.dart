import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_manager_app/presentation/cubit/event_cubit.dart';
import 'package:event_manager_app/domain/entities/event.dart';
import './event_detail_page.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late EventCubit _searchCubit;
  
  String _selectedCategory = 'Tất cả';
  String _selectedPriceRange = 'Tất cả';
  DateTime? _selectedDate;
  String _sortBy = 'Tên sự kiện';
  
  final List<String> _categories = [
    'Tất cả', 'music', 'technology', 'food', 'art', 'sport', 'comedy', 'shopping'
  ];
  
  final List<String> _categoryDisplayNames = [
    'Tất cả', 'Âm nhạc', 'Công nghệ', 'Ẩm thực', 'Nghệ thuật', 'Thể thao', 'Hài kịch', 'Mua sắm'
  ];
  
  final List<String> _priceRanges = [
    'Tất cả', 'Miễn phí', 'Dưới 1.000.000₫', 
    '1.000.000₫ - 3.000.000₫', 'Trên 3.000.000₫'
  ];
  
  final List<String> _sortOptions = [
    'Tên sự kiện', 'Ngày diễn ra', 'Giá vé (Thấp đến Cao)', 'Giá vé (Cao đến Thấp)'
  ];

  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _searchCubit = EventCubit.create();
    _searchController.addListener(_onSearchChanged);
    
    // Load all events initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchEvents();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchCubit.close();
    super.dispose();
  }

  void _onSearchChanged() {
    // Debounce the search to avoid too many API calls
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text == _searchController.text) {
        _searchEvents();
      }
    });
  }

  void _searchEvents() {
    final query = _searchController.text.trim();
    final category = _selectedCategory == 'Tất cả' ? null : _selectedCategory;
    
    double? minPrice, maxPrice;
    if (_selectedPriceRange != 'Tất cả') {
      final priceRange = _getPriceRange(_selectedPriceRange);
      minPrice = priceRange['min'];
      maxPrice = priceRange['max'];
    }

    _searchCubit.searchEvents(
      query: query.isEmpty ? null : query,
      category: category,
      dateFrom: _selectedDate,
      dateTo: _selectedDate,
      minPrice: minPrice,
      maxPrice: maxPrice,
      limit: 50,
    );
  }

  Map<String, double?> _getPriceRange(String range) {
    switch (range) {
      case 'Miễn phí':
        return {'min': 0.0, 'max': 0.0};
      case 'Dưới 1.000.000₫':
        return {'min': 0.0, 'max': 1000000.0};
      case '1.000.000₫ - 3.000.000₫':
        return {'min': 1000000.0, 'max': 3000000.0};
      case 'Trên 3.000.000₫':
        return {'min': 3000000.0, 'max': null};
      default:
        return {'min': null, 'max': null};
    }
  }

  List<EventEntity> _sortEvents(List<EventEntity> events) {
    List<EventEntity> sortedEvents = List.from(events);
    
    switch (_sortBy) {
      case 'Tên sự kiện':
        sortedEvents.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Ngày diễn ra':
        sortedEvents.sort((a, b) => a.startTime.compareTo(b.startTime));
        break;
      case 'Giá vé (Thấp đến Cao)':
        sortedEvents.sort((a, b) => a.eventId.compareTo(b.eventId));
        break;
      case 'Giá vé (Cao đến Thấp)':
        sortedEvents.sort((a, b) => b.eventId.compareTo(a.eventId));
        break;
    }
    
    return sortedEvents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: const Text(
          'Tìm kiếm sự kiện',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[850],
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sự kiện, địa điểm, ban tổ chức...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: const Icon(Icons.search, color: Colors.orange),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          
          // Filters
          if (_showFilters) _buildFiltersSection(),
          
          // Results
          Expanded(
            child: BlocBuilder<EventCubit, EventState>(
              bloc: _searchCubit,
              builder: (context, state) {
                if (state is EventLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  );
                } else if (state is EventLoaded) {
                  final sortedEvents = _sortEvents(state.events);
                  
                  if (sortedEvents.isEmpty) {
                    return _buildEmptyState();
                  }
                  
                  return Column(
                    children: [
                      // Results count and sort options
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tìm thấy ${sortedEvents.length} sự kiện',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            DropdownButton<String>(
                              value: _sortBy,
                              dropdownColor: Colors.grey[800],
                              style: const TextStyle(color: Colors.white),
                              items: _sortOptions.map((option) {
                                return DropdownMenuItem(
                                  value: option,
                                  child: Text(
                                    option,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _sortBy = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      // Events list
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: sortedEvents.length,
                          itemBuilder: (context, index) {
                            return _buildEventCard(sortedEvents[index]);
                          },
                        ),
                      ),
                    ],
                  );
                } else if (state is EventError) {
                  return _buildErrorState(state.message);
                }
                
                return _buildEmptyState();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[850],
      child: Column(
        children: [
          // Category filter
          Row(
            children: [
              const Text(
                'Danh mục: ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  dropdownColor: Colors.grey[800],
                  style: const TextStyle(color: Colors.white),
                  items: _categories.asMap().entries.map((entry) {
                    final index = entry.key;
                    final category = entry.value;
                    final displayName = _categoryDisplayNames[index];
                    return DropdownMenuItem(
                      value: category,
                      child: Text(displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                    _searchEvents();
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Price range filter
          Row(
            children: [
              const Text(
                'Giá vé: ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedPriceRange,
                  isExpanded: true,
                  dropdownColor: Colors.grey[800],
                  style: const TextStyle(color: Colors.white),
                  items: _priceRanges.map((range) {
                    return DropdownMenuItem(
                      value: range,
                      child: Text(range),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPriceRange = value!;
                    });
                    _searchEvents();
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Date filter
          Row(
            children: [
              const Text(
                'Ngày: ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[600]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate != null
                              ? _formatDate(_selectedDate!)
                              : 'Chọn ngày',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.orange),
                      ],
                    ),
                  ),
                ),
              ),
              if (_selectedDate != null)
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _selectedDate = null;
                    });
                    _searchEvents();
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.orange,
              onPrimary: Colors.white,
              surface: Colors.grey,
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
      _searchEvents();
    }
  }

  Widget _buildEventCard(EventEntity event) {
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
        margin: const EdgeInsets.only(bottom: 16),
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
            // Event image
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
              child: Center(
                child: event.img != null && event.img!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(16),
                        ),
                        child: Image.network(
                          event.img!,
                          width: 120,
                          height: 120,
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
            
            // Event details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getCategoryDisplayName(event.category),
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Title
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
                    
                    // Date and time
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.grey[400],
                          size: 14,
                        ),
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
                    
                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.grey[400],
                          size: 14,
                        ),
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
                  ],
                ),
              ),
            ),
            
            // Action button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            color: Colors.grey[400],
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Không tìm thấy sự kiện nào',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thử thay đổi từ khóa tìm kiếm hoặc bộ lọc',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _searchEvents,
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

  String _getCategoryDisplayName(String category) {
    final lowerCategory = category.toLowerCase();
    switch (lowerCategory) {
      case 'music':
        return 'Âm nhạc';
      case 'technology':
        return 'Công nghệ';
      case 'food':
        return 'Ẩm thực';
      case 'art':
        return 'Nghệ thuật';
      case 'sport':
      case 'sports':
        return 'Thể thao';
      case 'comedy':
        return 'Hài kịch';
      case 'shopping':
        return 'Mua sắm';
      default:
        return category;
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
}
