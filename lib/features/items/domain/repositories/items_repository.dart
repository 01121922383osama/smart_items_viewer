import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/item_entity.dart';

abstract class ItemsRepository {
  Future<Either<Failure, PageResult<ItemEntity>>> getPage({
    required int page,
    required int limit,
  });

  Future<Either<Failure, PageResult<ItemEntity>>> refreshItems({
    required int limit,
  });

  Future<void> cachePage({
    required int page,
    required List<ItemEntity> items,
    required DateTime fetchedAt,
  });

  Future<CachedSnapshot<ItemEntity>?> readCachedSnapshot();

  Future<void> clearCache();

  Future<bool> hasCachedData();
}
