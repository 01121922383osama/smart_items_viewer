import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/item_entity.dart';

class ItemsState extends Equatable {
  final List<ItemEntity> items;
  final bool isLoadingInitial;
  final bool isLoadingMore;
  final bool isRefreshing;
  final bool hasNext;
  final Failure? failure;
  final bool isStale;
  final int currentPage;

  const ItemsState({
    this.items = const [],
    this.isLoadingInitial = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.hasNext = true,
    this.failure,
    this.isStale = false,
    this.currentPage = 1,
  });

  ItemsState copyWith({
    List<ItemEntity>? items,
    bool? isLoadingInitial,
    bool? isLoadingMore,
    bool? isRefreshing,
    bool? hasNext,
    Failure? failure,
    bool? isStale,
    int? currentPage,
  }) {
    return ItemsState(
      items: items ?? this.items,
      isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      hasNext: hasNext ?? this.hasNext,
      failure: failure ?? this.failure,
      isStale: isStale ?? this.isStale,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
    items,
    isLoadingInitial,
    isLoadingMore,
    isRefreshing,
    hasNext,
    failure,
    isStale,
    currentPage,
  ];
}
