import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class TMDBService {
  static const String _apiKey = 'c08be6ce047d51687a69242e81d28512';
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _imageBase = 'https://image.tmdb.org/t/p/w500';

  static String imageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return '$_imageBase$path';
  }

  static Future<List<Movie>> searchMovies(String query, {String? type}) async {
    if (query.trim().isEmpty) return [];

    String endpoint;
    switch (type) {
      case 'tv':
        endpoint = '/search/tv';
        break;
      case 'anime':
        endpoint = '/search/tv';
        break;
      default:
        endpoint = '/search/movie';
    }

    final uri = Uri.parse('$_baseUrl$endpoint').replace(queryParameters: {
      'api_key': _apiKey,
      'query': query,
      'language': 'ru-RU',
      if (type == 'anime') 'with_genres': '16',
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((e) => Movie.fromJson(e)).toList();
    }
    return [];
  }

  static Future<Movie?> getMovieDetails(int id, {bool isTv = false}) async {
    final endpoint = isTv ? '/tv/$id' : '/movie/$id';
    final uri = Uri.parse('$_baseUrl$endpoint').replace(queryParameters: {
      'api_key': _apiKey,
      'language': 'ru-RU',
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return Movie.fromJson(json.decode(response.body));
    }
    return null;
  }

  static Future<List<Movie>> getTrending() async {
    final uri = Uri.parse('$_baseUrl/trending/movie/week').replace(queryParameters: {
      'api_key': _apiKey,
      'language': 'ru-RU',
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((e) => Movie.fromJson(e)).toList();
    }
    return [];
  }
}
