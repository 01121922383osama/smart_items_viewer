import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/pagination_utils.dart';
import '../../domain/entities/item_entity.dart';
import '../../domain/repositories/items_repository.dart';
import '../../domain/usecases/get_items_page.dart';
import '../../domain/usecases/refresh_items.dart';
import 'items_state.dart';

class ItemsCubit extends Cubit<ItemsState> {
  final GetItemsPage _getItemsPage;
  final RefreshItems _refreshItems;
  final ItemsRepository _repository;

  ItemsCubit({
    required GetItemsPage getItemsPage,
    required RefreshItems refreshItems,
    required ItemsRepository repository,
  }) : _getItemsPage = getItemsPage,
       _refreshItems = refreshItems,
       _repository = repository,
       super(const ItemsState());

  Future<void> loadInitial() async {
    Logger.info('Starting loadInitial', tag: 'ItemsCubit');
    emit(state.copyWith(isLoadingInitial: true, failure: null));

    try {
      final cachedSnapshot = await _repository.readCachedSnapshot();

      if (cachedSnapshot != null) {
        Logger.info(
          'Found cached data: ${cachedSnapshot.data.length} items',
          tag: 'ItemsCubit',
        );
        emit(
          state.copyWith(
            items: cachedSnapshot.data,
            isLoadingInitial: false,
            isStale: cachedSnapshot.isStale,
          ),
        );
      } else {
        Logger.info('No cached data found', tag: 'ItemsCubit');
      }

      final result = await _getItemsPage(
        page: 1,
        limit: PaginationUtils.defaultLimit,
      );

      result.fold(
        (failure) {
          Logger.error(
            'Failed to load items',
            tag: 'ItemsCubit',
            error: failure,
          );

          if (cachedSnapshot != null) {
            emit(state.copyWith(isLoadingInitial: false, isStale: true));
          } else {
            emit(state.copyWith(isLoadingInitial: false, failure: failure));
          }
        },
        (pageResult) {
          Logger.info(
            'Successfully loaded ${pageResult.data.length} items',
            tag: 'ItemsCubit',
          );
          emit(
            state.copyWith(
              items: pageResult.data,
              isLoadingInitial: false,
              hasNext: pageResult.hasNext,
              currentPage: 1,
              isStale: false,
              failure: null,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingInitial: false,
          failure: const UnexpectedFailure(
            message: 'An unexpected error occurred',
          ),
        ),
      );
    }
  }

  Future<void> loadMore() async {
    Logger.info(
      'loadMore called: isLoadingMore=${state.isLoadingMore}, hasNext=${state.hasNext}',
      tag: 'ItemsCubit',
    );

    if (state.isLoadingMore || !state.hasNext) {
      Logger.info(
        'loadMore skipped: isLoadingMore=${state.isLoadingMore}, hasNext=${state.hasNext}',
        tag: 'ItemsCubit',
      );
      return;
    }

    Logger.info(
      'Starting loadMore for page ${state.currentPage + 1}',
      tag: 'ItemsCubit',
    );
    emit(state.copyWith(isLoadingMore: true));

    try {
      final result = await _getItemsPage(
        page: state.currentPage + 1,
        limit: PaginationUtils.defaultLimit,
      );

      result.fold(
        (failure) {
          emit(state.copyWith(isLoadingMore: false, failure: failure));
        },
        (pageResult) {
          final updatedItems = List<ItemEntity>.from(state.items)
            ..addAll(pageResult.data);

          emit(
            state.copyWith(
              items: updatedItems,
              isLoadingMore: false,
              hasNext: pageResult.hasNext,
              currentPage: state.currentPage + 1,
              failure: null,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingMore: false,
          failure: const UnexpectedFailure(
            message: 'An unexpected error occurred',
          ),
        ),
      );
    }
  }

  Future<void> pullToRefresh() async {
    emit(state.copyWith(isRefreshing: true, failure: null));

    try {
      final result = await _refreshItems(limit: PaginationUtils.defaultLimit);

      result.fold(
        (failure) {
          emit(state.copyWith(isRefreshing: false, failure: failure));
        },
        (pageResult) {
          emit(
            state.copyWith(
              items: pageResult.data,
              isRefreshing: false,
              hasNext: pageResult.hasNext,
              currentPage: 1,
              isStale: false,
              failure: null,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          isRefreshing: false,
          failure: const UnexpectedFailure(
            message: 'An unexpected error occurred',
          ),
        ),
      );
    }
  }

  void clearError() {
    emit(state.copyWith(failure: null));
  }
}
