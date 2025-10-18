import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/items_cubit.dart';
import '../cubit/items_state.dart';
import '../widgets/empty_widget.dart';
import '../widgets/items_list_widget.dart';
import '../widgets/language_dialog_widget.dart';
import '../widgets/network_status_widget.dart';
import '../widgets/shimmer_list_widget.dart';
import '../widgets/theme_dialog_widget.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  late final ScrollController _scrollController;
  late final ItemsCubit _cubit;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _cubit = sl<ItemsCubit>();

    _scrollController.addListener(_onScroll);
    _cubit.loadInitial();
  }

  void _onScroll() {
    final position = _scrollController.position;
    final threshold = position.maxScrollExtent * 0.8;

    log(
      'Scroll Debug: pixels=${position.pixels}, maxScrollExtent=${position.maxScrollExtent}, threshold=$threshold',
    );
    log(
      'Scroll Debug: isLoadingMore=$_isLoadingMore, hasNext=${_cubit.state.hasNext}',
    );

    if (position.pixels >= threshold) {
      if (!_isLoadingMore && _cubit.state.hasNext) {
        log('Loading more items...');
        _isLoadingMore = true;
        _cubit.loadMore();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).items),
        actions: [
          const NetworkStatusWidget(),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _showLanguageDialog,
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: _showThemeDialog,
          ),
        ],
      ),
      body: BlocConsumer<ItemsCubit, ItemsState>(
        bloc: _cubit,
        listener: (context, state) {
          if (state.isLoadingMore) {
            _isLoadingMore = true;
          } else {
            _isLoadingMore = false;
          }

          if (state.failure != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure!.message),
                action: SnackBarAction(
                  label: AppLocalizations.of(context).retry,
                  onPressed: () => _cubit.clearError(),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => _cubit.pullToRefresh(),
            child: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ItemsState state) {
    if (state.isLoadingInitial && state.items.isEmpty) {
      return const ShimmerListWidget();
    }

    if (state.items.isEmpty && !state.isLoadingInitial) {
      return EmptyWidget(
        message: AppLocalizations.of(context).emptyList,
        onRetry: () => _cubit.loadInitial(),
      );
    }

    return ItemsListWidget(scrollController: _scrollController, cubit: _cubit);
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => const LanguageDialogWidget(),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => const ThemeDialogWidget(),
    );
  }
}
