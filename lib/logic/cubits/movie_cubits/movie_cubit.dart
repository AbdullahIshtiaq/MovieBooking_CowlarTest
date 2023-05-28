import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../data/model/movie_model.dart';
import '../../../data/model/movie_video_model.dart';
import '../../../data/repo/movie_repo.dart';
import 'movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieCubit extends Cubit<MovieState> {
  MovieRepository movieRepository = MovieRepository();
  MovieCubit() : super(MovieInitialState());

  late Movie? movie;

  void fetchMovieByID(String movieId) async {
    emit(MovieLoadingState());
    try {
      movie = await movieRepository.fetchMovieByID(movieId);
      if (movie != null) {
        emit(MovieLoadedState(movie!));
      }
    } catch (ex) {
      emit(MovieErrorState(ex.toString(), null));
    }
  }

  void fetchMovieVideos(String movieId) async {
    try {
      MovieVideos? movieVideos =
          await movieRepository.fetchMovieVideos(movieId);

      if (movieVideos != null) {
        if (movieVideos.results.isNotEmpty) {
          YoutubePlayerController controller = YoutubePlayerController(
            initialVideoId:
                YoutubePlayer.convertUrlToId(movieVideos.results[0].key)
                    .toString(),
            flags: const YoutubePlayerFlags(
              autoPlay: true,
              mute: false,
            ),
          );
          emit(MovieVideosLoadedState(movieVideos, controller));
        } else {
          emit(MovieErrorState("No Trailer Found!", movie!));
        }
      } else {
        emit(MovieErrorState("No Trailer Found!", movie!));
      }
    } catch (ex) {
      emit(MovieErrorState(ex.toString(), movie!));
    }
  }

  void stopVideo() {
    emit(MovieLoadedState(movie!));
  }
}
