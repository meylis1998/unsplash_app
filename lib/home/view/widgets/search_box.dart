part of '../photo_detail.dart';

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
