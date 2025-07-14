import 'package:event_manager_app/domain/entities/event.dart';
import 'organizer_model.dart';

class EventModel {
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
  final double? ticketPrice;
  final int? availableTickets;
  final int? hotRank;
  final bool? isHot;

  EventModel({
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
    this.ticketPrice,
    this.availableTickets,
    this.hotRank,
    this.isHot,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['EventID'] ?? json['id'] ?? 0,
      title: json['Title'] ?? json['title'] ?? '',
      description: json['Description'] ?? json['description'] ?? '',
      category: json['Category'] ?? json['category'] ?? '',
      location: json['Location'] ?? json['location'] ?? '',
      img: json['Img'] ?? json['image_url'] ?? json['img'],
      startTime: DateTime.parse(json['StartTime'] ?? json['start_time'] ?? json['event_date'] ?? DateTime.now().toIso8601String()),
      endTime: DateTime.parse(json['EndTime'] ?? json['end_time'] ?? DateTime.now().add(Duration(hours: 2)).toIso8601String()),
      capacity: json['Capacity'] ?? json['capacity'] ?? json['available_tickets'] ?? 0,
      organizerId: json['OrganizerID'] ?? json['organizer_id'] ?? 0,
      status: json['Status'] ?? json['status'] ?? 'draft',
      createdAt: DateTime.parse(json['CreatedAt'] ?? json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['UpdatedAt'] ?? json['updated_at'] ?? DateTime.now().toIso8601String()),
      ticketPrice: (json['ticket_price'] ?? json['TicketPrice'])?.toDouble(),
      availableTickets: json['available_tickets'] ?? json['AvailableTickets'],
      hotRank: json['hot_rank'] ?? json['HotRank'],
      isHot: json['is_hot'] ?? json['IsHot'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': eventId,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'image_url': img,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'capacity': capacity,
      'organizer_id': organizerId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'ticket_price': ticketPrice,
      'available_tickets': availableTickets,
      'hot_rank': hotRank,
      'is_hot': isHot,
    };
  }

  EventEntity toEntity() {
    return EventEntity(
      eventId: eventId,
      title: title,
      description: description,
      category: category,
      location: location,
      img: img,
      startTime: startTime,
      endTime: endTime,
      capacity: capacity,
      organizerId: organizerId,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory EventModel.fromEntity(EventEntity entity) {
    return EventModel(
      eventId: entity.eventId,
      title: entity.title,
      description: entity.description,
      category: entity.category,
      location: entity.location,
      img: entity.img,
      startTime: entity.startTime,
      endTime: entity.endTime,
      capacity: entity.capacity,
      organizerId: entity.organizerId,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

class EventWithOrganizerModel {
  final EventModel event;
  final OrganizerModel organizer;

  EventWithOrganizerModel({
    required this.event,
    required this.organizer,
  });

  factory EventWithOrganizerModel.fromJson(Map<String, dynamic> json) {
    return EventWithOrganizerModel(
      event: EventModel.fromJson(json['event']),
      organizer: OrganizerModel.fromJson(json['organizer']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event': event.toJson(),
      'organizer': organizer.toJson(),
    };
  }

  EventWithOrganizerEntity toEntity() {
    return EventWithOrganizerEntity(
      event: event.toEntity(),
      organizer: organizer.toEntity(),
    );
  }
}
