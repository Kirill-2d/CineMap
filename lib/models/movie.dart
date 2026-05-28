class Movie {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final double rating;
  final String? releaseDate;
  final String? overview;
  final List<String> originCountry;
  final String? originalLanguage;
  final bool isTV;

  Movie({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    required this.rating,
    this.releaseDate,
    this.overview,
    this.originCountry = const [],
    this.originalLanguage,
    this.isTV = false,
  });

  String get year {
    if (releaseDate == null || releaseDate!.isEmpty) return '';
    return releaseDate!.substring(0, 4);
  }

  String get country {
    if (originCountry.isNotEmpty) return originCountry.first;
    if (originalLanguage != null) return originalLanguage!.toUpperCase();
    return '';
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    final isTV = json.containsKey('first_air_date');
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      rating: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? json['first_air_date'],
      overview: json['overview'],
      originCountry: List<String>.from(json['origin_country'] ?? []),
      originalLanguage: json['original_language'],
      isTV: isTV,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'vote_average': rating,
    'release_date': releaseDate,
    'overview': overview,
    'origin_country': originCountry,
    'original_language': originalLanguage,
    'is_tv': isTV,
  };
}
