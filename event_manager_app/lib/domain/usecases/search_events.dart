import 'package:dartz/dartz.dart';
import 'package:event_manager_app/core/error/failures.dart';
import 'package:event_manager_app/core/usecase/usecase.dart';
import 'package:event_manager_app/domain/entities/event.dart';
import 'package:event_manager_app/domain/repository/event_repository.dart';

class SearchEventsUseCase implements Usecase<Either<Failure, List<EventEntity>>, EventSearchParams> {
  final EventRepository repository;

  SearchEventsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<EventEntity>>> call(EventSearchParams params) async {
    return await repository.searchEvents(
      query: params.query,
      category: params.category,
      location: params.location,
      dateFrom: params.dateFrom,
      dateTo: params.dateTo,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class EventSearchParams {
  final String? query;
  final String? category;
  final String? location;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final double? minPrice;
  final double? maxPrice;
  final int? limit;
  final int? offset;

  EventSearchParams({
    this.query,
    this.category,
    this.location,
    this.dateFrom,
    this.dateTo,
    this.minPrice,
    this.maxPrice,
    this.limit,
    this.offset,
  });
}
