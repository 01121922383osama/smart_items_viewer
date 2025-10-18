import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../cubit/items_cubit.dart';
import '../cubit/items_state.dart';
import 'item_card.dart';
import 'loading_indicator.dart';
import 'stale_indicator.dart';

class ItemsListWidget extends StatelessWidget {
  final ScrollController scrollController;
  final ItemsCubit cubit;

  const ItemsListWidget({
    super.key,
    required this.scrollController,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsCubit, ItemsState>(
      bloc: cubit,
      builder: (context, state) {
        return Stack(
          children: [
            ListView.builder(
              controller: scrollController,
              itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.items.length) {
                  return const LoadingIndicator();
                }

                final item = state.items[index];
                return ItemCard(item: item);
              },
            ),
            if (state.isStale)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: StaleIndicator(
                  message: AppLocalizations.of(context).cachedDataShown,
                ),
              ),
          ],
        );
      },
    );
  }
}
