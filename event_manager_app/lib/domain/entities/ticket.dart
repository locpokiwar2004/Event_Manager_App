class TicketEntity {
  final int ticketId;
  final int eventId;
  final String name;
  final double price;
  final int onePer;
  final int quantityTotal;
  final int quantitySold;

  TicketEntity({
    required this.ticketId,
    required this.eventId,
    required this.name,
    required this.price,
    required this.onePer,
    required this.quantityTotal,
    required this.quantitySold,
  });

  int get availableQuantity => quantityTotal - quantitySold;
  bool get isAvailable => availableQuantity > 0;
}
