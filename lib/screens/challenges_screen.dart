import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  static const _challenges = [
    {'title': 'Кинофестиваль', 'desc': 'Посмотри 5 фильмов-лауреатов', 'progress': 0.4, 'icon': '🏆'},
    {'title': 'Вокруг света', 'desc': 'Фильмы из 10 разных стран', 'progress': 0.7, 'icon': '🌍'},
    {'title': 'Классика', 'desc': '10 фильмов до 1980 года', 'progress': 0.2, 'icon': '🎞️'},
    {'title': 'Аниме-марафон', 'desc': 'Посмотри 7 аниме', 'progress': 0.1, 'icon': '⛩️'},
    {'title': 'Триллер-ночь', 'desc': '3 триллера за выходные', 'progress': 0.0, 'icon': '🔪'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Челленджи',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _challenges.length,
                itemBuilder: (_, i) {
                  final c = _challenges[i];
                  final progress = c['progress'] as double;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.cardBorder),
                    ),
                    child: Row(
                      children: [
                        Text(c['icon'] as String, style: const TextStyle(fontSize: 32)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c['title'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                c['desc'] as String,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: AppTheme.cardBorder,
                                  valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
                                  minHeight: 6,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${(progress * 100).round()}%',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
