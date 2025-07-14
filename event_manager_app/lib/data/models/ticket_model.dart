import '../../domain/entities/ticket.dart';

class TicketModel extends TicketEntity {
  TicketModel({
    required super.ticketId,
    required super.eventId,
    required super.name,
    required super.price,
    required super.onePer,
    required super.quantityTotal,
    required super.quantitySold,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      ticketId: json['TicketID'] ?? json['ticketId'] ?? 0,
      eventId: json['EventID'] ?? json['eventId'] ?? 0,
      name: json['Name'] ?? json['name'] ?? '',
      price: (json['Price'] ?? json['price'] ?? 0.0).toDouble(),
      onePer: json['OnePer'] ?? json['onePer'] ?? 1,
      quantityTotal: json['QuantityTotal'] ?? json['quantityTotal'] ?? 0,
      quantitySold: json['QuantitySold'] ?? json['quantitySold'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TicketID': ticketId,
      'EventID': eventId,
      'Name': name,
      'Price': price,
      'OnePer': onePer,
      'QuantityTotal': quantityTotal,
      'QuantitySold': quantitySold,
    };
  }
}
