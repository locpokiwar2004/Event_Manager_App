// Event Status Enum
enum EventStatus { draft, published, cancelled }

extension EventStatusExtension on EventStatus {
  String get value {
    switch (this) {
      case EventStatus.draft:
        return 'draft';
      case EventStatus.published:
        return 'published';
      case EventStatus.cancelled:
        return 'cancelled';
    }
  }

  static EventStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return EventStatus.draft;
      case 'published':
        return EventStatus.published;
      case 'cancelled':
        return EventStatus.cancelled;
      default:
        return EventStatus.draft;
    }
  }
}

// Organizer Info Model
class OrganizerInfo {
  final int userId;
  final String fullName;
  final String email;
  final String? phone;
  final String? address;

  const OrganizerInfo({
    required this.userId,
    required this.fullName,
    required this.email,
    this.phone,
    this.address,
  });

  factory OrganizerInfo.fromJson(Map<String, dynamic> json) {
    return OrganizerInfo(
      userId: json['UserID'] as int,
      fullName: json['FullName'] as String,
      email: json['Email'] as String,
      phone: json['Phone'] as String?,
      address: json['Address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserID': userId,
      'FullName': fullName,
      'Email': email,
      if (phone != null) 'Phone': phone,
      if (address != null) 'Address': address,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrganizerInfo &&
        other.userId == userId &&
        other.fullName == fullName &&
        other.email == email &&
        other.phone == phone &&
        other.address == address;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        fullName.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        address.hashCode;
  }
}

// Event Model
class Event {
  final int? eventId;
  final String title;
  final String description;
  final String category;
  final String location;
  final String? img;
  final DateTime startTime;
  final DateTime endTime;
  final int capacity;
  final int organizerId;
  final EventStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final OrganizerInfo? organizer;

  const Event({
    this.eventId,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    this.img,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    required this.organizerId,
    this.status = EventStatus.draft,
    this.createdAt,
    this.updatedAt,
    this.organizer,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['EventID'] as int?,
      title: json['Title'] as String,
      description: json['Description'] as String,
      category: json['Category'] as String,
      location: json['Location'] as String,
      img: json['Img'] as String?,
      startTime: DateTime.parse(json['StartTime'] as String),
      endTime: DateTime.parse(json['EndTime'] as String),
      capacity: json['Capacity'] as int,
      organizerId: json['OrganizerID'] as int,
      status: EventStatusExtension.fromString(json['Status'] as String),
      createdAt: json['CreatedAt'] != null 
          ? DateTime.parse(json['CreatedAt'] as String) 
          : null,
      updatedAt: json['UpdatedAt'] != null 
          ? DateTime.parse(json['UpdatedAt'] as String) 
          : null,
      organizer: json['Organizer'] != null 
          ? OrganizerInfo.fromJson(json['Organizer'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (eventId != null) 'EventID': eventId,
      'Title': title,
      'Description': description,
      'Category': category,
      'Location': location,
      if (img != null) 'Img': img,
      'StartTime': startTime.toIso8601String(),
      'EndTime': endTime.toIso8601String(),
      'Capacity': capacity,
      'OrganizerID': organizerId,
      'Status': status.value,
      if (createdAt != null) 'CreatedAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'UpdatedAt': updatedAt!.toIso8601String(),
      if (organizer != null) 'Organizer': organizer!.toJson(),
    };
  }

  Event copyWith({
    int? eventId,
    String? title,
    String? description,
    String? category,
    String? location,
    String? img,
    DateTime? startTime,
    DateTime? endTime,
    int? capacity,
    int? organizerId,
    EventStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    OrganizerInfo? organizer,
  }) {
    return Event(
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      location: location ?? this.location,
      img: img ?? this.img,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      capacity: capacity ?? this.capacity,
      organizerId: organizerId ?? this.organizerId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      organizer: organizer ?? this.organizer,
    );
  }

  // Helper methods
  String get formattedStartDate {
    return '${startTime.day}/${startTime.month}/${startTime.year}';
  }

  String get formattedStartTime {
    return '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
  }

  String get formattedEndDate {
    return '${endTime.day}/${endTime.month}/${endTime.year}';
  }

  String get formattedEndTime {
    return '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
  }

  String get formattedDateRange {
    if (startTime.day == endTime.day && 
        startTime.month == endTime.month && 
        startTime.year == endTime.year) {
      return '${formattedStartDate} • ${formattedStartTime} - ${formattedEndTime}';
    } else {
      return '${formattedStartDate} ${formattedStartTime} - ${formattedEndDate} ${formattedEndTime}';
    }
  }

  Duration get duration {
    return endTime.difference(startTime);
  }

  String get formattedDuration {
    final diff = duration;
    if (diff.inDays > 0) {
      return '${diff.inDays} day(s)';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hour(s)';
    } else {
      return '${diff.inMinutes} minute(s)';
    }
  }

  bool get isUpcoming {
    return startTime.isAfter(DateTime.now());
  }

  bool get isOngoing {
    final now = DateTime.now();
    return startTime.isBefore(now) && endTime.isAfter(now);
  }

  bool get isPast {
    return endTime.isBefore(DateTime.now());
  }

  String get statusDisplay {
    if (isPast) return 'Ended';
    if (isOngoing) return 'Ongoing';
    if (isUpcoming) return 'Upcoming';
    return status.value.toUpperCase();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Event &&
        other.eventId == eventId &&
        other.title == title &&
        other.category == category &&
        other.startTime == startTime;
  }

  @override
  int get hashCode {
    return eventId.hashCode ^
        title.hashCode ^
        category.hashCode ^
        startTime.hashCode;
  }

  @override
  String toString() {
    return 'Event(id: $eventId, title: $title, status: $status, startTime: $startTime)';
  }
}

// Event Request Models for API calls
class EventCreateRequest {
  final String title;
  final String description;
  final String category;
  final String location;
  final String? img;
  final DateTime startTime;
  final DateTime endTime;
  final int capacity;
  final int organizerId;

  const EventCreateRequest({
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    this.img,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    required this.organizerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Description': description,
      'Category': category,
      'Location': location,
      if (img != null) 'Img': img,
      'StartTime': startTime.toIso8601String(),
      'EndTime': endTime.toIso8601String(),
      'Capacity': capacity,
      'OrganizerID': organizerId,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventCreateRequest &&
        other.title == title &&
        other.category == category &&
        other.startTime == startTime;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        category.hashCode ^
        startTime.hashCode;
  }
}

class EventUpdateRequest {
  final String? title;
  final String? description;
  final String? category;
  final String? location;
  final String? img;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? capacity;
  final EventStatus? status;

  const EventUpdateRequest({
    this.title,
    this.description,
    this.category,
    this.location,
    this.img,
    this.startTime,
    this.endTime,
    this.capacity,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'Title': title,
      if (description != null) 'Description': description,
      if (category != null) 'Category': category,
      if (location != null) 'Location': location,
      if (img != null) 'Img': img,
      if (startTime != null) 'StartTime': startTime!.toIso8601String(),
      if (endTime != null) 'EndTime': endTime!.toIso8601String(),
      if (capacity != null) 'Capacity': capacity,
      if (status != null) 'Status': status!.value,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventUpdateRequest &&
        other.title == title &&
        other.category == category;
  }

  @override
  int get hashCode {
    return title.hashCode ^ category.hashCode;
  }
}

class EventStatusUpdateRequest {
  final EventStatus status;

  const EventStatusUpdateRequest({required this.status});

  Map<String, dynamic> toJson() {
    return {
      'Status': status.value,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventStatusUpdateRequest &&
        other.status == status;
  }

  @override
  int get hashCode => status.hashCode;
}

// Event List Response Model
class EventListResponse {
  final List<Event> events;
  final int? totalCount;
  final int? currentPage;
  final int? totalPages;

  const EventListResponse({
    required this.events,
    this.totalCount,
    this.currentPage,
    this.totalPages,
  });

  factory EventListResponse.fromJson(Map<String, dynamic> json) {
    return EventListResponse(
      events: (json['events'] as List?)
          ?.map((eventJson) => Event.fromJson(eventJson as Map<String, dynamic>))
          .toList() ?? [],
      totalCount: json['total_count'] as int?,
      currentPage: json['current_page'] as int?,
      totalPages: json['total_pages'] as int?,
    );
  }

  // For when API returns list directly
  factory EventListResponse.fromList(List<dynamic> eventList) {
    return EventListResponse(
      events: eventList
          .map((eventJson) => Event.fromJson(eventJson as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventListResponse &&
        other.events == events &&
        other.totalCount == totalCount;
  }

  @override
  int get hashCode {
    return events.hashCode ^ totalCount.hashCode;
  }
}

// Event Categories
class EventCategory {
  static const String music = 'Music';
  static const String technology = 'Technology';
  static const String sports = 'Sports';
  static const String foodAndDrinks = 'Food & Drinks';
  static const String education = 'Education';
  static const String business = 'Business';
  static const String health = 'Health';
  static const String entertainment = 'Entertainment';
  static const String art = 'Art';
  static const String travel = 'Travel';
  static const String networking = 'Networking';
  static const String workshop = 'Workshop';

  static const List<String> all = [
    music,
    technology,
    sports,
    foodAndDrinks,
    education,
    business,
    health,
    entertainment,
    art,
    travel,
    networking,
    workshop,
  ];

  static String getDisplayName(String category) {
    switch (category) {
      case music:
        return '🎵 Music';
      case technology:
        return '💻 Technology';
      case sports:
        return '⚽ Sports';
      case foodAndDrinks:
        return '🍕 Food & Drinks';
      case education:
        return '📚 Education';
      case business:
        return '💼 Business';
      case health:
        return '🏥 Health';
      case entertainment:
        return '🎭 Entertainment';
      case art:
        return '🎨 Art';
      case travel:
        return '✈️ Travel';
      case networking:
        return '🤝 Networking';
      case workshop:
        return '🔧 Workshop';
      default:
        return category;
    }
  }
}
