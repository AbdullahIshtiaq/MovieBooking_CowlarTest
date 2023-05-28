import '../../../data/floor_db/database.dart';
import '../../../data/floor_db/movie_dao.dart';
import '../../../data/floor_db/movie_entity.dart';
import '../../../data/model/movie_model.dart';
import '../../../data/repo/movie_repo.dart';
import 'movies_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MovieRepository movieRepository = MovieRepository();

  List<Movie> movies = [];
  List<Movie> searchedMovies = [];

  MoviesCubit() : super(MoviesInitialState()) {
    initialize();
  }

  void initialize() async {
    emit(MoviesLoadingState());
    try {
      AppDatabase database =
          await $FloorAppDatabase.databaseBuilder('movies.db').build();
      MovieDao movieDao = database.movieDao;

      List<MovieEntity> moviesListDB = await movieDao.getAllMovies();

      if (moviesListDB.isNotEmpty) {
        movies = moviesListDB
            .map((e) => Movie(
                  genreIds:
                      e.genreIds.split(",").map((e) => int.parse(e)).toList(),
                  id: e.id,
                  originalTitle: e.title,
                  overview: e.overview,
                  posterPath: e.posterPath,
                  backdropPath: e.backdropPath,
                  releaseDate: e.releaseDate,
                  genres: [],
                ))
            .toList();

        emit(MoviesLoadedState(movies));
      } else {
        fetchMovies(movieDao);
      }
    } catch (ex) {
      emit(MoviesErrorState(ex.toString()));
    }
  }

  void fetchMovies(MovieDao movieDao) async {
    try {
      await movieDao.deleteAllMovies();
      movies = await movieRepository.fetchMovies();

      List<MovieEntity> moviesListDB = movies
          .map((e) => MovieEntity(
                id: e.id,
                title: e.originalTitle,
                overview: e.overview,
                posterPath: e.posterPath,
                backdropPath: e.backdropPath,
                releaseDate: e.releaseDate,
                genreIds: e.genreIds?.map((e) => e).join(",") ?? "",
              ))
          .toList();

      await movieDao.insertMovies(moviesListDB);
      emit(MoviesLoadedState(movies));
    } catch (ex) {
      emit(MoviesErrorState(ex.toString()));
    }
  }

  void searchMovies(String word) async {
    emit(MoviesLoadingState());
    try {
      searchedMovies = await movieRepository.searchMovies(word);
      emit(ShowSearchResultState(searchedMovies));
    } catch (ex) {
      emit(MoviesErrorState(ex.toString()));
    }
  }

  void openSearch() {
    emit(SearchOpenedState(movies));
  }

  void closeSearch() {
    emit(SearchClosedState(movies));
  }

  void showResult(List<Movie> movies) {
    emit(ShowSearchResultState(movies));
  }

  void searchComplete() {
    emit(SearchResultShowedState(searchedMovies));
  }
}
