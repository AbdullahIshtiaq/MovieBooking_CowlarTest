class MoviesCollection {
  MoviesCollection({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });
  late final Dates? dates;
  late final int page;
  late final List<Results> results;
  late final int totalPages;
  late final int totalResults;

  MoviesCollection.fromJson(Map<String, dynamic> json) {
    if (json['dates'] != null) {
      dates = Dates.fromJson(json['dates']);
    }
    page = json['page'];
    results =
        List.from(json['results']).map((e) => Results.fromJson(e)).toList();
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['dates'] = dates?.toJson();
    _data['page'] = page;
    _data['results'] = results.map((e) => e.toJson()).toList();
    _data['total_pages'] = totalPages;
    _data['total_results'] = totalResults;
    return _data;
  }
}

class Dates {
  Dates({
    required this.maximum,
    required this.minimum,
  });
  late final String maximum;
  late final String minimum;

  Dates.fromJson(Map<String, dynamic> json) {
    maximum = json['maximum'];
    minimum = json['minimum'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['maximum'] = maximum;
    _data['minimum'] = minimum;
    return _data;
  }
}

class Results {
  Results({
    required this.genreIds,
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.title,
    required this.movieGenre,
  });

  late final List<int> genreIds;
  late final int id;
  late final String originalTitle;
  late final String overview;
  late final String posterPath;
  late final String backdropPath;
  late final String releaseDate;
  late final String title;
  late String? movieGenre = 'None';

  Results.fromJson(Map<String, dynamic> json) {
    genreIds = List.castFrom<dynamic, int>(json['genre_ids']);
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
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['genre_ids'] = genreIds;
    _data['id'] = id;
    _data['original_title'] = originalTitle;
    _data['overview'] = overview;
    _data['poster_path'] = posterPath;
    _data['backdrop_path'] = backdropPath;
    _data['release_date'] = releaseDate;
    _data['title'] = title;
    return _data;
  }
}
