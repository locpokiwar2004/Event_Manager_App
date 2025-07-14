import 'package:dartz/dartz.dart';
import '../entities/ticket.dart';
import '../repository/ticket_repository.dart';

class GetEventTickets {
  final TicketRepository repository;

  GetEventTickets(this.repository);

  Future<Either<String, List<TicketEntity>>> call(int eventId) async {
    return await repository.getEventTickets(eventId);
  }
}

class CreateTicket {
  final TicketRepository repository;

  CreateTicket(this.repository);

  Future<Either<String, TicketEntity>> call(TicketEntity ticket) async {
    return await repository.createTicket(ticket);
  }
}

class GetAllTickets {
  final TicketRepository repository;

  GetAllTickets(this.repository);

  Future<Either<String, List<TicketEntity>>> call() async {
    return await repository.getAllTickets();
  }
}
