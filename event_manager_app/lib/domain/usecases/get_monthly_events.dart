import 'package:dartz/dartz.dart';
import 'package:event_manager_app/core/error/failures.dart';
import 'package:event_manager_app/core/usecase/usecase.dart';
import 'package:event_manager_app/domain/entities/event.dart';
import 'package:event_manager_app/domain/repository/event_repository.dart';

class GetMonthlyEventsUseCase implements Usecase<Either<Failure, List<EventEntity>>, MonthlyEventsParams> {
  final EventRepository repository;

  GetMonthlyEventsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<EventEntity>>> call(MonthlyEventsParams params) async {
    return await repository.getMonthlyEvents(
      year: params.year,
      month: params.month,
    );
  }
}

class MonthlyEventsParams {
  final int year;
  final int month;

  MonthlyEventsParams({
    required this.year,
    required this.month,
  });
}
