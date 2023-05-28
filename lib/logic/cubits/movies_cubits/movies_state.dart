import 'package:cowlar_entry_test_app/data/model/movie_model.dart';

abstract class MoviesState {}

class MoviesInitialState extends MoviesState {}

class MoviesLoadingState extends MoviesState {}

class MoviesLoadedState extends MoviesState {
  final List<Movie> movies;
  MoviesLoadedState(this.movies);
}

class MoviesErrorState extends MoviesState {
  final String error;
  MoviesErrorState(this.error);
}

class SearchOpenedState extends MoviesState {
  final List<Movie> movies;
  SearchOpenedState(this.movies);
}

class SearchClosedState extends MoviesState {
  final List<Movie> movies;
  SearchClosedState(this.movies);
}

class ShowSearchResultState extends MoviesState {
  final List<Movie> movies;
  ShowSearchResultState(this.movies);
}

class SearchResultShowedState extends MoviesState {
  final List<Movie> movies;
  SearchResultShowedState(this.movies);
}
