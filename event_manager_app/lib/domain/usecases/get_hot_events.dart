import 'package:dartz/dartz.dart';
import 'package:event_manager_app/core/error/failures.dart';
import 'package:event_manager_app/core/usecase/usecase.dart';
import 'package:event_manager_app/domain/entities/event.dart';
import 'package:event_manager_app/domain/repository/event_repository.dart';

class GetHotEventsUseCase implements Usecase<Either<Failure, List<EventEntity>>, GetHotEventsParams> {
  final EventRepository repository;

  GetHotEventsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<EventEntity>>> call(GetHotEventsParams params) async {
    return await repository.getHotEvents(limit: params.limit);
  }
}

class GetHotEventsParams {
  final int limit;

  GetHotEventsParams({this.limit = 10});
}
