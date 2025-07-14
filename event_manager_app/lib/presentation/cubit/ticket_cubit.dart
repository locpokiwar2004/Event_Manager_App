import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/usecases/ticket_use_cases.dart';
import '../../server_locator.dart';

abstract class TicketState {}

class TicketInitial extends TicketState {}

class TicketLoading extends TicketState {}

class TicketSuccess extends TicketState {
  final List<TicketEntity> tickets;
  
  TicketSuccess(this.tickets);
}

class TicketError extends TicketState {
  final String message;
  
  TicketError(this.message);
}

class TicketCubit extends Cubit<TicketState> {
  final GetEventTickets _getEventTickets;
  final CreateTicket _createTicket;
  final GetAllTickets _getAllTickets;

  TicketCubit(
    this._getEventTickets,
    this._createTicket,
    this._getAllTickets,
  ) : super(TicketInitial());

  factory TicketCubit.create() {
    return TicketCubit(
      sl<GetEventTickets>(),
      sl<CreateTicket>(),
      sl<GetAllTickets>(),
    );
  }

  Future<void> getEventTickets(int eventId) async {
    try {
      emit(TicketLoading());
      print('TicketCubit: Getting tickets for event $eventId');
      
      final result = await _getEventTickets(eventId);
      
      result.fold(
        (error) {
          print('TicketCubit error: $error');
          emit(TicketError(error));
        },
        (tickets) {
          print('TicketCubit success: ${tickets.length} tickets loaded');
          emit(TicketSuccess(tickets));
        },
      );
    } catch (e) {
      print('TicketCubit exception: $e');
      emit(TicketError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> createTicket(TicketEntity ticket) async {
    try {
      emit(TicketLoading());
      print('TicketCubit: Creating ticket');
      
      final result = await _createTicket(ticket);
      
      result.fold(
        (error) {
          print('TicketCubit create error: $error');
          emit(TicketError(error));
        },
        (ticket) {
          print('TicketCubit create success: ticket ${ticket.ticketId}');
          // Optionally reload all tickets or just add the new one
          getAllTickets();
        },
      );
    } catch (e) {
      print('TicketCubit create exception: $e');
      emit(TicketError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> getAllTickets() async {
    try {
      emit(TicketLoading());
      print('TicketCubit: Getting all tickets');
      
      final result = await _getAllTickets();
      
      result.fold(
        (error) {
          print('TicketCubit error: $error');
          emit(TicketError(error));
        },
        (tickets) {
          print('TicketCubit success: ${tickets.length} tickets loaded');
          emit(TicketSuccess(tickets));
        },
      );
    } catch (e) {
      print('TicketCubit exception: $e');
      emit(TicketError('Unexpected error: ${e.toString()}'));
    }
  }
}
