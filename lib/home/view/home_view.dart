import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:unsplash_app/favorites/cubit/favorites_cubit.dart';

import '../../app/config/config.dart';
import '../bloc/home_bloc.dart';
import 'widgets/photo_card.dart';

part 'widgets/empty_search.dart';
part 'widgets/empty_state.dart';
part 'widgets/error.dart';
part 'widgets/loading.dart';
part 'widgets/photo_list.dart';
part 'widgets/search_results.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.black,
        toolbarHeight: 80.h,
        title: SvgPicture.asset('assets/icons/logo.svg', width: Constants.deviceWidth(context) / 3),
        actions: [
          IconButton(
            color: AppTheme.white,
            iconSize: 30.sp,
            icon: const Icon(CupertinoIcons.heart),
            onPressed: () {
              context.push(AppRoutes.favorites);
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          // Show search results if user is searching
          if (state.isSearching) {
            return _buildSearchView(context, state);
          }

          // Show regular photos if not searching
          switch (state.status) {
            case LoadingStatus.loading:
              return const _LoadingWidget();

            case LoadingStatus.done:
              if (state.photos.isEmpty) {
                return const _EmptyStateWidget();
              }
              return _PhotoListWidget(photos: state.photos);

            case LoadingStatus.error:
              return _ErrorWidget(
                onRetry: () {
                  context.read<HomeBloc>().add(const PhotosGet());
                },
              );

            default:
              return const _LoadingWidget();
          }
        },
      ),
    );
  }

  Widget _buildSearchView(BuildContext context, HomeState state) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SearchBoxWidget()),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // Search results header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  'Результаты поиска: "${state.searchQuery}"',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(const SearchClear());
                  },
                  child: const Text('Очистить'),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 10)),

        // Search results content
        _buildSearchResults(context, state),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context, HomeState state) {
    switch (state.searchStatus) {
      case LoadingStatus.loading:
        return const SliverToBoxAdapter(child: _LoadingWidget());

      case LoadingStatus.done:
        if (state.searchResults.isEmpty) {
          return SliverToBoxAdapter(child: _EmptySearchWidget(query: state.searchQuery));
        }
        return _SearchResultsWidget(photos: state.searchResults);

      case LoadingStatus.error:
        return SliverToBoxAdapter(
          child: _ErrorWidget(
            message: 'Ошибка поиска',
            onRetry: () {
              context.read<HomeBloc>().add(PhotosSearch(state.searchQuery));
            },
          ),
        );

      default:
        return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
  }
}

class SearchBoxWidget extends StatefulWidget {
  @override
  State<SearchBoxWidget> createState() => _SearchBoxWidgetState();
}

class _SearchBoxWidgetState extends State<SearchBoxWidget> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  StreamSubscription<HomeState>? _blocSubscription;

  @override
  void initState() {
    super.initState();
    // Listen to HomeBloc state to update search box when search is cleared
    _blocSubscription = context.read<HomeBloc>().stream.listen((state) {
      if (!state.isSearching && _searchController.text.isNotEmpty && mounted) {
        _searchController.clear();
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _blocSubscription?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {}); // Update UI to show/hide clear button
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        if (query.trim().isEmpty) {
          context.read<HomeBloc>().add(const SearchClear());
        } else {
          context.read<HomeBloc>().add(PhotosSearch(query.trim()));
        }
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {}); // Update UI immediately
    _debounceTimer?.cancel();
    context.read<HomeBloc>().add(const SearchClear());
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/background.png'), fit: BoxFit.cover),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Поиск',
                  hintStyle: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.black, fontSize: 18),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: Icon(CupertinoIcons.clear_circled_solid, color: Colors.grey[600]),
                          onPressed: _clearSearch,
                        ),
                      IconButton(
                        icon: Icon(CupertinoIcons.search, color: Colors.grey[600]),
                        onPressed: () {
                          final text = _searchController.text.trim();
                          if (text.isNotEmpty) {
                            context.read<HomeBloc>().add(PhotosSearch(text));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
