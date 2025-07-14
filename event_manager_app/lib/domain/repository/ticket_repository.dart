import 'package:dartz/dartz.dart';
import '../entities/ticket.dart';

abstract class TicketRepository {
  Future<Either<String, List<TicketEntity>>> getEventTickets(int eventId);
  Future<Either<String, TicketEntity>> createTicket(TicketEntity ticket);
  Future<Either<String, List<TicketEntity>>> getAllTickets();
}
