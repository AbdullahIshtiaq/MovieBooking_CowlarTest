import 'package:floor/floor.dart';
import 'movie_entity.dart';

@dao
abstract class MovieDao {
  @Query('SELECT * FROM MovieEntity')
  Future<List<MovieEntity>> getAllMovies();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMovies(List<MovieEntity> movies);

  @Query('SELECT * FROM MovieEntity WHERE id = :id')
  Future<MovieEntity?> getMovieById(int id);

  @insert
  Future<void> insertMovie(MovieEntity movie);

  @update
  Future<void> updateMovie(MovieEntity movie);

  @delete
  Future<void> deleteMovie(MovieEntity movie);

  @Query('DELETE * FROM MovieEntity')
  Future<void> deleteAllMovies();
}
