import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';
import '../widgets/movie_result_card.dart';
import '../theme/app_theme.dart';

enum SearchFilter { all, movies, tv, anime }

final searchQueryProvider = StateProvider<String>((ref) => '');
final searchFilterProvider = StateProvider<SearchFilter>((ref) => SearchFilter.all);
final searchResultsProvider = FutureProvider.autoDispose<List<Movie>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final filter = ref.watch(searchFilterProvider);
  if (query.trim().isEmpty) return [];

  String? type;
  switch (filter) {
    case SearchFilter.tv:
      type = 'tv';
      break;
    case SearchFilter.anime:
      type = 'anime';
      break;
    default:
      type = null;
  }

  if (filter == SearchFilter.all) {
    final movies = await TMDBService.searchMovies(query, type: null);
    final tv = await TMDBService.searchMovies(query, type: 'tv');
    final combined = [...movies, ...tv];
    combined.sort((a, b) => b.rating.compareTo(a.rating));
    return combined;
  }

  return TMDBService.searchMovies(query, type: type);
});

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _debounce = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (_controller.text == _debounce.value) return;
        _debounce.value = _controller.text;
        ref.read(searchQueryProvider.notifier).state = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(searchFilterProvider);
    final results = ref.watch(searchResultsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  const Text(
                    'Поиск фильма',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.primary.withOpacity(0.1),
                    child: const Icon(Icons.person, color: AppTheme.primary, size: 20),
                  ),
                ],
              ),
            ),
            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Название фильма или страна...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _controller.clear();
                            ref.read(searchQueryProvider.notifier).state = '';
                          },
                        )
                      : null,
                ),
                onSubmitted: (v) => ref.read(searchQueryProvider.notifier).state = v,
              ),
            ),
            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: SearchFilter.values.map((f) {
                  final labels = {
                    SearchFilter.all: 'Все',
                    SearchFilter.movies: 'Фильмы',
                    SearchFilter.tv: 'Сериалы',
                    SearchFilter.anime: 'Аниме',
                  };
                  final selected = filter == f;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(labels[f]!),
                      selected: selected,
                      onSelected: (_) => ref.read(searchFilterProvider.notifier).state = f,
                      selectedColor: AppTheme.primary,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : AppTheme.textSecondary,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color: selected ? AppTheme.primary : AppTheme.cardBorder,
                      ),
                      backgroundColor: AppTheme.surface,
                    ),
                  );
                }).toList(),
              ),
            ),
            // Results
            Expanded(
              child: results.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppTheme.primary),
                ),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: AppTheme.textSecondary),
                      const SizedBox(height: 8),
                      Text('Ошибка: $e', style: const TextStyle(color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
                data: (movies) {
                  if (_controller.text.isEmpty) {
                    return _emptyState('Введите название фильма\nили страну производства');
                  }
                  if (movies.isEmpty) {
                    return _emptyState('Не нашли нужный фильм?\nПопробуйте уточнить запрос');
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                        child: Text(
                          'Результаты поиска',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: movies.length,
                          itemBuilder: (_, i) => MovieResultCard(movie: movies[i]),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(String text) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.info_outline, size: 48, color: AppTheme.textSecondary.withOpacity(0.5)),
        const SizedBox(height: 12),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
        ),
      ],
    ),
  );
}
