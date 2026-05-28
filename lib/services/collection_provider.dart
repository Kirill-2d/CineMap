import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';

final collectionProvider = StateNotifierProvider<CollectionNotifier, List<Movie>>((ref) {
  return CollectionNotifier();
});

class CollectionNotifier extends StateNotifier<List<Movie>> {
  CollectionNotifier() : super([]) {
    _load();
  }

  static const _key = 'collection';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    state = data.map((e) => Movie.fromJson(json.decode(e))).toList();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      state.map((e) => json.encode(e.toJson())).toList(),
    );
  }

  bool contains(int id) => state.any((m) => m.id == id);

  void toggle(Movie movie) {
    if (contains(movie.id)) {
      state = state.where((m) => m.id != movie.id).toList();
    } else {
      state = [...state, movie];
    }
    _save();
  }

  void remove(int id) {
    state = state.where((m) => m.id != id).toList();
    _save();
  }
}
