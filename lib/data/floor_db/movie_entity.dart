import 'package:floor/floor.dart';

@entity
class MovieEntity {
  @PrimaryKey()
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final String genreIds;
  final String genre;
  final String videoKey;

  MovieEntity({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.genreIds,
    this.videoKey = '',
    this.genre = 'Nill',
  });
}
