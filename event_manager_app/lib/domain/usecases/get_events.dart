import 'package:dartz/dartz.dart';
import 'package:event_manager_app/core/error/failures.dart';
import 'package:event_manager_app/core/usecase/usecase.dart';
import 'package:event_manager_app/domain/entities/event.dart';
import 'package:event_manager_app/domain/repository/event_repository.dart';

class GetEventsUseCase implements Usecase<Either<Failure, List<EventEntity>>, NoParams> {
  final EventRepository repository;

  GetEventsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<EventEntity>>> call(NoParams params) async {
    return await repository.getEvents();
  }
}

class NoParams {}
