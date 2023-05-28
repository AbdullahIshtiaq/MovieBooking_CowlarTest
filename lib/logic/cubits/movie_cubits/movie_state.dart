import 'package:cowlar_entry_test_app/data/model/movie_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../data/model/movie_video_model.dart';

abstract class MovieState {}

class MovieInitialState extends MovieState {}

class MovieLoadingState extends MovieState {}

class MovieLoadedState extends MovieState {
  final Movie movie;
  MovieLoadedState(this.movie);
}

class MovieVideosLoadedState extends MovieState {
  final MovieVideos movieVideos;
  final YoutubePlayerController controller;
  MovieVideosLoadedState(this.movieVideos, this.controller);
}

class MovieErrorState extends MovieState {
  final String error;
  final Movie? movie;
  MovieErrorState(this.error, this.movie);
}
