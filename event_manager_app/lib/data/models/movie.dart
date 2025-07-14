class Movie {
  final int? id;
  final String title;
  final String description;
  final String? posterUrl;
  final String? backdropUrl;
  final double? rating;
  final String? releaseDate;
  final List<String>? genres;
  final int? duration; // in minutes
  final String? director;
  final List<String>? cast;
  final String? trailerUrl;
  final bool isPopular;
  final bool isUpcoming;
  final bool isNowPlaying;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Movie({
    this.id,
    required this.title,
    required this.description,
    this.posterUrl,
    this.backdropUrl,
    this.rating,
    this.releaseDate,
    this.genres,
    this.duration,
    this.director,
    this.cast,
    this.trailerUrl,
    this.isPopular = false,
    this.isUpcoming = false,
    this.isNowPlaying = false,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create Movie from JSON
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String,
      posterUrl: json['poster_url'] as String?,
      backdropUrl: json['backdrop_url'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      releaseDate: json['release_date'] as String?,
      genres: json['genres'] != null 
          ? List<String>.from(json['genres'] as List) 
          : null,
      duration: json['duration'] as int?,
      director: json['director'] as String?,
      cast: json['cast'] != null 
          ? List<String>.from(json['cast'] as List) 
          : null,
      trailerUrl: json['trailer_url'] as String?,
      isPopular: json['is_popular'] as bool? ?? false,
      isUpcoming: json['is_upcoming'] as bool? ?? false,
      isNowPlaying: json['is_now_playing'] as bool? ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
    );
  }

  // Method to convert Movie to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'poster_url': posterUrl,
      'backdrop_url': backdropUrl,
      'rating': rating,
      'release_date': releaseDate,
      'genres': genres,
      'duration': duration,
      'director': director,
      'cast': cast,
      'trailer_url': trailerUrl,
      'is_popular': isPopular,
      'is_upcoming': isUpcoming,
      'is_now_playing': isNowPlaying,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Method to create a copy of Movie with updated fields
  Movie copyWith({
    int? id,
    String? title,
    String? description,
    String? posterUrl,
    String? backdropUrl,
    double? rating,
    String? releaseDate,
    List<String>? genres,
    int? duration,
    String? director,
    List<String>? cast,
    String? trailerUrl,
    bool? isPopular,
    bool? isUpcoming,
    bool? isNowPlaying,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      posterUrl: posterUrl ?? this.posterUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      rating: rating ?? this.rating,
      releaseDate: releaseDate ?? this.releaseDate,
      genres: genres ?? this.genres,
      duration: duration ?? this.duration,
      director: director ?? this.director,
      cast: cast ?? this.cast,
      trailerUrl: trailerUrl ?? this.trailerUrl,
      isPopular: isPopular ?? this.isPopular,
      isUpcoming: isUpcoming ?? this.isUpcoming,
      isNowPlaying: isNowPlaying ?? this.isNowPlaying,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Method to get formatted duration string
  String get formattedDuration {
    if (duration == null) return 'Duration not available';
    final hours = duration! ~/ 60;
    final minutes = duration! % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  // Method to get star rating string
  String get starRating {
    if (rating == null) return 'No rating';
    return '★' * (rating! / 2).round() + '☆' * (5 - (rating! / 2).round());
  }

  // Method to get genres as a formatted string
  String get genresString {
    if (genres == null || genres!.isEmpty) return 'No genres';
    return genres!.join(', ');
  }

  // Method to get cast as a formatted string
  String get castString {
    if (cast == null || cast!.isEmpty) return 'Cast not available';
    return cast!.join(', ');
  }

  @override
  String toString() {
    return 'Movie(id: $id, title: $title, rating: $rating, isPopular: $isPopular)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Movie && other.id == id && other.title == title;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}

// Movie category/filter models
enum MovieCategory {
  popular,
  upcoming,
  nowPlaying,
  topRated,
  action,
  comedy,
  drama,
  horror,
  romance,
  sciFi,
  thriller,
  animation,
  documentary,
}

extension MovieCategoryExtension on MovieCategory {
  String get displayName {
    switch (this) {
      case MovieCategory.popular:
        return 'Popular';
      case MovieCategory.upcoming:
        return 'Upcoming';
      case MovieCategory.nowPlaying:
        return 'Now Playing';
      case MovieCategory.topRated:
        return 'Top Rated';
      case MovieCategory.action:
        return 'Action';
      case MovieCategory.comedy:
        return 'Comedy';
      case MovieCategory.drama:
        return 'Drama';
      case MovieCategory.horror:
        return 'Horror';
      case MovieCategory.romance:
        return 'Romance';
      case MovieCategory.sciFi:
        return 'Sci-Fi';
      case MovieCategory.thriller:
        return 'Thriller';
      case MovieCategory.animation:
        return 'Animation';
      case MovieCategory.documentary:
        return 'Documentary';
    }
  }
}

// Movie request/response models for API
class MovieListResponse {
  final List<Movie> movies;
  final int totalPages;
  final int currentPage;
  final int totalResults;

  MovieListResponse({
    required this.movies,
    required this.totalPages,
    required this.currentPage,
    required this.totalResults,
  });

  factory MovieListResponse.fromJson(Map<String, dynamic> json) {
    return MovieListResponse(
      movies: (json['movies'] as List)
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList(),
      totalPages: json['total_pages'] as int,
      currentPage: json['current_page'] as int,
      totalResults: json['total_results'] as int,
    );
  }
}

class MovieRequest {
  final String? title;
  final String? description;
  final String? posterUrl;
  final String? backdropUrl;
  final double? rating;
  final String? releaseDate;
  final List<String>? genres;
  final int? duration;
  final String? director;
  final List<String>? cast;
  final String? trailerUrl;

  MovieRequest({
    this.title,
    this.description,
    this.posterUrl,
    this.backdropUrl,
    this.rating,
    this.releaseDate,
    this.genres,
    this.duration,
    this.director,
    this.cast,
    this.trailerUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (posterUrl != null) 'poster_url': posterUrl,
      if (backdropUrl != null) 'backdrop_url': backdropUrl,
      if (rating != null) 'rating': rating,
      if (releaseDate != null) 'release_date': releaseDate,
      if (genres != null) 'genres': genres,
      if (duration != null) 'duration': duration,
      if (director != null) 'director': director,
      if (cast != null) 'cast': cast,
      if (trailerUrl != null) 'trailer_url': trailerUrl,
    };
  }
}
