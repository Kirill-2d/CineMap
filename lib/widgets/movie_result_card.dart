import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';
import '../services/collection_provider.dart';
import '../theme/app_theme.dart';

class MovieResultCard extends ConsumerWidget {
  final Movie movie;
  final VoidCallback? onTap;

  const MovieResultCard({super.key, required this.movie, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inCollection = ref.watch(collectionProvider).any((m) => m.id == movie.id);
    final posterUrl = TMDBService.imageUrl(movie.posterPath);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: posterUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: posterUrl,
                      width: 72,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        width: 72,
                        height: 100,
                        color: AppTheme.cardBorder,
                      ),
                      errorWidget: (_, __, ___) => _posterPlaceholder(),
                    )
                  : _posterPlaceholder(),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (movie.year.isNotEmpty)
                        Text(
                          movie.year,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (movie.country.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 12, color: AppTheme.primary),
                        const SizedBox(width: 4),
                        Text(
                          movie.country,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Rating
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 14, color: AppTheme.accent),
                            const SizedBox(width: 4),
                            Text(
                              movie.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Add to collection button
                      GestureDetector(
                        onTap: () => ref.read(collectionProvider.notifier).toggle(movie),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: inCollection ? AppTheme.primary : AppTheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                inCollection ? Icons.check : Icons.add,
                                size: 14,
                                color: inCollection ? Colors.white : AppTheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                inCollection ? 'В коллекции' : 'В коллекцию',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: inCollection ? Colors.white : AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _posterPlaceholder() => Container(
    width: 72,
    height: 100,
    decoration: BoxDecoration(
      color: AppTheme.cardBorder,
      borderRadius: BorderRadius.circular(10),
    ),
    child: const Icon(Icons.movie, color: AppTheme.textSecondary),
  );
}
