import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cowlar_entry_test_app/logic/cubits/movie_cubits/movie_cubit.dart';
import 'package:cowlar_entry_test_app/presentation/ticket_booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../constants.dart';
import '../logic/cubits/movie_cubits/movie_state.dart';
import '../utils.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key, required this.movieId});

  final String movieId;
  final imageBaseURl = "https://image.tmdb.org/t/p/original";

  void resestOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return BlocProvider(
      create: (context) => MovieCubit(),
      child: BlocBuilder<MovieCubit, MovieState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              if (state is MovieVideosLoadedState) {
                BlocProvider.of<MovieCubit>(context).stopVideo();
                return false;
              } else {
                return true;
              }
            },
            child: Scaffold(
              body: BlocConsumer<MovieCubit, MovieState>(
                listener: (context, state) {
                  if (state is MovieErrorState) {
                    SnackBar snackBar = SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.red,
                      duration: const Duration(milliseconds: 500),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                builder: (context, state) {
                  return OrientationBuilder(
                    builder: (BuildContext context, Orientation orientation) {
                      if (state is MovieInitialState) {
                        BlocProvider.of<MovieCubit>(context)
                            .fetchMovieByID(movieId);
                      }

                      if (state is MovieLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (orientation == Orientation.portrait) {
                        if (state is MovieLoadedState ||
                            state is MovieErrorState) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Column(
                                children: [
                                  screenFirstHalf(context, state),
                                  screenSecondHalf(context, state),
                                ],
                              ),
                            ],
                          );
                        }

                        if (state is MovieVideosLoadedState) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Positioned.fill(
                                child: AnimatedOpacity(
                                  opacity: 0.7,
                                  duration: const Duration(seconds: 1),
                                  child: YoutubePlayer(
                                    controller: state.controller,
                                    showVideoProgressIndicator: true,
                                    progressIndicatorColor: blue,
                                    progressColors: const ProgressBarColors(
                                      playedColor: Colors.blue,
                                      handleColor: blue,
                                    ),
                                    onEnded: (data) {
                                      resestOrientation();
                                      BlocProvider.of<MovieCubit>(context)
                                          .stopVideo();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }

                      if (orientation == Orientation.landscape) {
                        if (state is MovieLoadedState ||
                            state is MovieErrorState) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Row(
                                children: [
                                  screenFirstHalf(context, state),
                                  screenSecondHalf(context, state),
                                ],
                              ),
                            ],
                          );
                        }

                        if (state is MovieVideosLoadedState) {
                          return YoutubePlayer(
                            controller: state.controller,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: blue,
                            progressColors: const ProgressBarColors(
                              playedColor: Colors.blue,
                              handleColor: blue,
                            ),
                            onEnded: (data) {
                              resestOrientation();
                              BlocProvider.of<MovieCubit>(context).stopVideo();
                            },
                          );
                        }

                        if (state is MovieErrorState) {
                          return const SnackBar(
                              content: Text("No Trailer Found"));
                        }
                      }
                      return const SnackBar(content: Text("No Trailer Found"));
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget screenFirstHalf(context, state) {
    return Expanded(
      flex: 1,
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: (state.movie.backdropPath.isNotEmpty)
                  ? imageBaseURl + state.movie.backdropPath
                  : (state.movie.posterPath.isNotEmpty)
                      ? imageBaseURl + state.movie.posterPath
                      : "https://www.thermaxglobal.com/wp-content/uploads/2020/05/image-not-found.jpg",
            ),
          ),
          Positioned(
            top: 40.0,
            left: 16.0,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 8.0),
                const Text(
                  'Watch',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 20.0,
            right: 20.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  state.movie.originalTitle,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "In Theaters ${convertDateFormat(nullCheck(state.movie.releaseDate))}",
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                    width: 200,
                    height: 50,
                    child: RoundedButton(
                        text: "Get Tickets",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieTicketBookingScreen(
                                movieName: state.movie.originalTitle,
                                releaseDate: convertDateFormat(
                                    nullCheck(state.movie.releaseDate)),
                              ),
                            ),
                          );
                        })),
                const SizedBox(height: 16.0),
                SizedBox(
                    width: 200,
                    height: 50,
                    child: TransparentButton(
                        text: "Watch Trailer",
                        onPressed: () {
                          BlocProvider.of<MovieCubit>(context)
                              .fetchMovieVideos(movieId);
                        })),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget screenSecondHalf(context, state) {
    return Expanded(
      flex: 1,
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Genres',
                style: TextStyle(
                  fontSize: 20.0,
                  color: darkGray,
                ),
              ),
              const SizedBox(height: 8.0),
              HorizontalList(
                items: state.movie.genres!,
              ),
              const SizedBox(height: 15.0),
              const Divider(
                color: Color.fromARGB(255, 238, 232, 232),
                height: 1,
                thickness: 1,
              ),
              const SizedBox(height: 15.0),
              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 20.0,
                  color: darkGray,
                ),
              ),
              ParagraphText(text: nullCheck(state.movie.overview)),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const RoundedButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed as void Function()?,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16.0),
      ),
    );
  }
}

class TransparentButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const TransparentButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed as void Function()?,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        side: const BorderSide(color: blue, width: 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.play_arrow,
            color: Colors.white,
          ),
          const SizedBox(width: 8.0),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalList extends StatelessWidget {
  const HorizontalList({super.key, required this.items});

  final List<dynamic> items;

  Color _getRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          items.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: _getRandomColor(),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  items[index].name,
                  style: const TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ParagraphText extends StatelessWidget {
  final String text;

  const ParagraphText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            text,
            style: const TextStyle(fontSize: 13.0, color: lightGray),
          ),
        ),
      ),
    );
  }
}
