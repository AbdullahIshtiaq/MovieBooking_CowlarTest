class Movie {
  Movie({
    required this.genreIds,
    required this.genres,
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.backdropPath,
  });

  late final List<int>? genreIds;
  late final List<Genres>? genres;
  late final int id;
  late final String originalTitle;
  late final String overview;
  late final String posterPath;
  late final String releaseDate;
  late final String backdropPath;

  Movie.fromJson(Map<String, dynamic> json) {
    if (json['genres'] != null) {
      genres =
          List.from(json['genres']).map((e) => Genres.fromJson(e)).toList();
    } else {
      genres = [];
    }

    if (json['genre_ids'] != null) {
      genreIds = List.castFrom<dynamic, int>(json['genre_ids']);
    } else {
      genreIds = [];
    }

    id = json['id'];
    originalTitle = json['original_title'];
    overview = json['overview'];

    if (json['poster_path'] != null) {
      posterPath = json['poster_path'];
    } else {
      posterPath = "";
    }

    if (json['backdrop_path'] != null) {
      backdropPath = json['backdrop_path'];
    } else {
      backdropPath = "";
    }

    releaseDate = json['release_date'];
  }
}

class Genres {
  Genres({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  Genres.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
