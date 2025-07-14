class EventEntity {
  final int eventId;
  final String title;
  final String description;
  final String category;
  final String location;
  final String? img;
  final DateTime startTime;
  final DateTime endTime;
  final int capacity;
  final int organizerId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventEntity({
    required this.eventId,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    this.img,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    required this.organizerId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventEntity &&
        other.eventId == eventId &&
        other.title == title &&
        other.description == description &&
        other.category == category &&
        other.location == location &&
        other.img == img &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.capacity == capacity &&
        other.organizerId == organizerId &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return eventId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        category.hashCode ^
        location.hashCode ^
        img.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        capacity.hashCode ^
        organizerId.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'EventEntity(eventId: $eventId, title: $title, description: $description, category: $category, location: $location, img: $img, startTime: $startTime, endTime: $endTime, capacity: $capacity, organizerId: $organizerId, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  EventEntity copyWith({
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
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventEntity(
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
    );
  }
}

class OrganizerEntity {
  final int userId;
  final String fullName;
  final String email;
  final String? phone;
  final String? address;

  const OrganizerEntity({
    required this.userId,
    required this.fullName,
    required this.email,
    this.phone,
    this.address,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrganizerEntity &&
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

  @override
  String toString() {
    return 'OrganizerEntity(userId: $userId, fullName: $fullName, email: $email, phone: $phone, address: $address)';
  }

  OrganizerEntity copyWith({
    int? userId,
    String? fullName,
    String? email,
    String? phone,
    String? address,
  }) {
    return OrganizerEntity(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }
}

class EventWithOrganizerEntity {
  final EventEntity event;
  final OrganizerEntity organizer;

  const EventWithOrganizerEntity({
    required this.event,
    required this.organizer,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventWithOrganizerEntity &&
        other.event == event &&
        other.organizer == organizer;
  }

  @override
  int get hashCode => event.hashCode ^ organizer.hashCode;

  @override
  String toString() {
    return 'EventWithOrganizerEntity(event: $event, organizer: $organizer)';
  }

  EventWithOrganizerEntity copyWith({
    EventEntity? event,
    OrganizerEntity? organizer,
  }) {
    return EventWithOrganizerEntity(
      event: event ?? this.event,
      organizer: organizer ?? this.organizer,
    );
  }
}

// Enum for Event Status
enum EventStatus {
  draft('draft'),
  published('published'),
  cancelled('cancelled');

  const EventStatus(this.value);
  final String value;

  static EventStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return EventStatus.draft;
      case 'published':
        return EventStatus.published;
      case 'cancelled':
        return EventStatus.cancelled;
      default:
        throw ArgumentError('Invalid event status: $status');
    }
  }
}

// Search parameters entity
class EventSearchEntity {
  final String? query;
  final String? category;
  final String? location;
  final EventStatus? status;
  final int limit;

  const EventSearchEntity({
    this.query,
    this.category,
    this.location,
    this.status,
    this.limit = 20,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventSearchEntity &&
        other.query == query &&
        other.category == category &&
        other.location == location &&
        other.status == status &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    return query.hashCode ^
        category.hashCode ^
        location.hashCode ^
        status.hashCode ^
        limit.hashCode;
  }

  @override
  String toString() {
    return 'EventSearchEntity(query: $query, category: $category, location: $location, status: $status, limit: $limit)';
  }

  EventSearchEntity copyWith({
    String? query,
    String? category,
    String? location,
    EventStatus? status,
    int? limit,
  }) {
    return EventSearchEntity(
      query: query ?? this.query,
      category: category ?? this.category,
      location: location ?? this.location,
      status: status ?? this.status,
      limit: limit ?? this.limit,
    );
  }
}

// Monthly events parameters entity
class MonthlyEventsEntity {
  final int year;
  final int month;
  final EventStatus? status;
  final String? category;

  const MonthlyEventsEntity({
    required this.year,
    required this.month,
    this.status,
    this.category,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MonthlyEventsEntity &&
        other.year == year &&
        other.month == month &&
        other.status == status &&
        other.category == category;
  }

  @override
  int get hashCode {
    return year.hashCode ^ month.hashCode ^ status.hashCode ^ category.hashCode;
  }

  @override
  String toString() {
    return 'MonthlyEventsEntity(year: $year, month: $month, status: $status, category: $category)';
  }

  MonthlyEventsEntity copyWith({
    int? year,
    int? month,
    EventStatus? status,
    String? category,
  }) {
    return MonthlyEventsEntity(
      year: year ?? this.year,
      month: month ?? this.month,
      status: status ?? this.status,
      category: category ?? this.category,
    );
  }
}