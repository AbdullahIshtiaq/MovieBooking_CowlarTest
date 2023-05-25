class Movie {
  Movie({
    required this.genres,
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.backdropPath,
  });
  late final List<Genres> genres;
  late final int id;
  late final String originalTitle;
  late final String overview;
  late final String posterPath;
  late final String releaseDate;
  late final String title;
  late final bool video;
  late final String backdropPath;

  Movie.fromJson(Map<String, dynamic> json) {
    genres = List.from(json['genres']).map((e) => Genres.fromJson(e)).toList();

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

    title = json['title'];
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['genres'] = genres.map((e) => e.toJson()).toList();
    _data['id'] = id;
    _data['original_title'] = originalTitle;
    _data['overview'] = overview;
    _data['poster_path'] = posterPath;
    _data['backdrop_path'] = backdropPath;
    _data['release_date'] = releaseDate;
    _data['title'] = title;
    _data['video'] = video;
    return _data;
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

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}
