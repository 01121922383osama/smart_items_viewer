import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/item_entity.dart';
import '../repositories/items_repository.dart';

class GetItemsPage {
  final ItemsRepository repository;

  GetItemsPage(this.repository);

  Future<Either<Failure, PageResult<ItemEntity>>> call({
    required int page,
    required int limit,
  }) async {
    return await repository.getPage(page: page, limit: limit);
  }
}
