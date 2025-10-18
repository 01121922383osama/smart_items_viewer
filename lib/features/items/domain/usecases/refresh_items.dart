import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/item_entity.dart';
import '../repositories/items_repository.dart';

class RefreshItems {
  final ItemsRepository repository;

  RefreshItems(this.repository);

  Future<Either<Failure, PageResult<ItemEntity>>> call({
    required int limit,
  }) async {
    return await repository.refreshItems(limit: limit);
  }
}
