import 'package:dartz/dartz.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/repository/ticket_repository.dart';
import '../source/ticket_remote_data_source.dart';
import '../models/ticket_model.dart';

class TicketRepositoryImpl implements TicketRepository {
  final TicketRemoteDataSource remoteDataSource;

  TicketRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<TicketEntity>>> getEventTickets(int eventId) async {
    try {
      print('TicketRepositoryImpl: Getting tickets for event $eventId');
      final tickets = await remoteDataSource.getEventTickets(eventId);
      print('TicketRepositoryImpl: Retrieved ${tickets.length} tickets');
      return Right(tickets);
    } catch (e) {
      print('TicketRepositoryImpl error: $e');
      return Left('Failed to get event tickets: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, TicketEntity>> createTicket(TicketEntity ticket) async {
    try {
      print('TicketRepositoryImpl: Creating ticket');
      final ticketModel = TicketModel(
        ticketId: ticket.ticketId,
        eventId: ticket.eventId,
        name: ticket.name,
        price: ticket.price,
        onePer: ticket.onePer,
        quantityTotal: ticket.quantityTotal,
        quantitySold: ticket.quantitySold,
      );
      
      final createdTicket = await remoteDataSource.createTicket(ticketModel);
      print('TicketRepositoryImpl: Created ticket with ID ${createdTicket.ticketId}');
      return Right(createdTicket);
    } catch (e) {
      print('TicketRepositoryImpl error: $e');
      return Left('Failed to create ticket: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<TicketEntity>>> getAllTickets() async {
    try {
      print('TicketRepositoryImpl: Getting all tickets');
      final tickets = await remoteDataSource.getAllTickets();
      print('TicketRepositoryImpl: Retrieved ${tickets.length} tickets');
      return Right(tickets);
    } catch (e) {
      print('TicketRepositoryImpl error: $e');
      return Left('Failed to get all tickets: ${e.toString()}');
    }
  }
}
