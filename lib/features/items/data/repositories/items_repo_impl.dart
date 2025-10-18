import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/result_mapper.dart';
import '../../../../core/utils/time.dart';
import '../../domain/entities/item_entity.dart';
import '../../domain/repositories/items_repository.dart';
import '../datasources/items_local_ds.dart';
import '../datasources/items_remote_ds.dart';

class ItemsRepositoryImpl implements ItemsRepository {
  final ItemsRemoteDataSource _remoteDataSource;
  final ItemsLocalDataSource _localDataSource;

  ItemsRepositoryImpl({
    required ItemsRemoteDataSource remoteDataSource,
    required ItemsLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  Future<bool> _checkConnectivity() async {
    try {
      final results = await Connectivity().checkConnectivity();
      return results.any(
        (result) =>
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet,
      );
    } catch (e) {
      Logger.warning(
        'Failed to check connectivity: $e',
        tag: 'ItemsRepository',
      );
      return false;
    }
  }

  @override
  Future<Either<Failure, PageResult<ItemEntity>>> getPage({
    required int page,
    required int limit,
  }) async {
    try {
      final isOnline = await _checkConnectivity();
      Logger.info(
        'Network status: ${isOnline ? "Online" : "Offline"}',
        tag: 'ItemsRepository',
      );

      // Always try to get cached data first
      final cachedSnapshot = await _localDataSource.readCachedSnapshot();

      if (isOnline) {
        // ONLINE: Try to fetch fresh data from API
        try {
          Logger.info(
            'Fetching fresh data from API (page $page)',
            tag: 'ItemsRepository',
          );

          final response = await _remoteDataSource.getItemsPage(
            page: page,
            limit: limit,
          );

          Logger.info(
            'API Response: products=${response.products.length}, total=${response.total}',
            tag: 'ItemsRepository',
          );

          final pageResult = response.toEntity();
          Logger.info(
            'Successfully fetched ${pageResult.data.length} items from API',
            tag: 'ItemsRepository',
          );

          // Cache the fresh data
          await _localDataSource.cachePage(
            page: page,
            items: pageResult.data,
            fetchedAt: TimeUtils.now(),
          );

          return Right(pageResult);
        } catch (e) {
          Logger.warning(
            'API request failed, falling back to cached data',
            tag: 'ItemsRepository',
          );

          // If API fails, fall back to cached data if available
          if (cachedSnapshot != null) {
            Logger.info(
              'Using cached data as fallback',
              tag: 'ItemsRepository',
            );
            return Right(
              PageResult<ItemEntity>(
                data: cachedSnapshot.data,
                total: cachedSnapshot.data.length,
                skip: 0,
                limit: limit,
                hasNext: true,
              ),
            );
          }

          return handleException(e as Exception);
        }
      } else {
        // OFFLINE: Use cached data only
        Logger.info('Offline mode: Using cached data', tag: 'ItemsRepository');

        if (cachedSnapshot != null) {
          Logger.info(
            'Found cached data: ${cachedSnapshot.data.length} items',
            tag: 'ItemsRepository',
          );
          return Right(
            PageResult<ItemEntity>(
              data: cachedSnapshot.data,
              total: cachedSnapshot.data.length,
              skip: 0,
              limit: limit,
              hasNext: true,
            ),
          );
        } else {
          Logger.warning(
            'No cached data available in offline mode',
            tag: 'ItemsRepository',
          );
          return const Left(
            NetworkFailure(
              message: 'No internet connection and no cached data available',
              code: 'OFFLINE_NO_CACHE',
            ),
          );
        }
      }
    } catch (e) {
      Logger.error(
        'Unexpected error in getPage',
        tag: 'ItemsRepository',
        error: e,
      );
      return handleException(e as Exception);
    }
  }

  @override
  Future<Either<Failure, PageResult<ItemEntity>>> refreshItems({
    required int limit,
  }) async {
    try {
      final isOnline = await _checkConnectivity();
      Logger.info(
        'Refresh - Network status: ${isOnline ? "Online" : "Offline"}',
        tag: 'ItemsRepository',
      );

      if (!isOnline) {
        Logger.warning(
          'Cannot refresh in offline mode',
          tag: 'ItemsRepository',
        );
        return const Left(
          NetworkFailure(
            message: 'Cannot refresh data without internet connection',
            code: 'OFFLINE_REFRESH',
          ),
        );
      }

      // Clear cache and fetch fresh data
      await _localDataSource.clearCache();
      Logger.info('Cache cleared, fetching fresh data', tag: 'ItemsRepository');

      final response = await _remoteDataSource.getItemsPage(
        page: 1,
        limit: limit,
      );

      final pageResult = response.toEntity();
      Logger.info(
        'Successfully refreshed ${pageResult.data.length} items',
        tag: 'ItemsRepository',
      );

      await _localDataSource.cachePage(
        page: 1,
        items: pageResult.data,
        fetchedAt: TimeUtils.now(),
      );

      return Right(pageResult);
    } catch (e) {
      Logger.error('Failed to refresh items', tag: 'ItemsRepository', error: e);
      return handleException(e as Exception);
    }
  }

  @override
  Future<void> cachePage({
    required int page,
    required List<ItemEntity> items,
    required DateTime fetchedAt,
  }) async {
    try {
      await _localDataSource.cachePage(
        page: page,
        items: items,
        fetchedAt: fetchedAt,
      );
    } catch (e) {
      Logger.error(
        'Failed to cache page $page',
        tag: 'ItemsRepository',
        error: e,
      );
    }
  }

  @override
  Future<CachedSnapshot<ItemEntity>?> readCachedSnapshot() async {
    try {
      return await _localDataSource.readCachedSnapshot();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _localDataSource.clearCache();
    } catch (e) {
      Logger.error('Failed to clear cache', tag: 'ItemsRepository', error: e);
    }
  }

  @override
  Future<bool> hasCachedData() async {
    try {
      return await _localDataSource.hasCachedData();
    } catch (e) {
      return false;
    }
  }
}
