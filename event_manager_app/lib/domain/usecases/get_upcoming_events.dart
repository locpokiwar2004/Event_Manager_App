import 'package:dartz/dartz.dart';
import 'package:event_manager_app/core/error/failures.dart';
import 'package:event_manager_app/core/usecase/usecase.dart';
import 'package:event_manager_app/domain/entities/event.dart';
import 'package:event_manager_app/domain/repository/event_repository.dart';

class GetUpcomingEventsUseCase implements Usecase<Either<Failure, List<EventEntity>>, GetUpcomingEventsParams> {
  final EventRepository repository;

  GetUpcomingEventsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<EventEntity>>> call(GetUpcomingEventsParams params) async {
    return await repository.getUpcomingEvents(limit: params.limit);
  }
}

class GetUpcomingEventsParams {
  final int? limit;

  GetUpcomingEventsParams({
    this.limit,
  });
}
