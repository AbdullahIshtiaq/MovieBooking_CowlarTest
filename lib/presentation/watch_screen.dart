import 'package:cached_network_image/cached_network_image.dart';
import 'package:cowlar_entry_test_app/constants.dart';
import 'package:cowlar_entry_test_app/logic/cubits/movies_cubits/movies_cubit.dart';
import 'package:cowlar_entry_test_app/logic/cubits/movies_cubits/movies_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

import '../data/model/movie_model.dart';

import 'movie_screen.dart';

class WatchScreen extends StatelessWidget {
  WatchScreen({super.key});

  TextEditingController _searchController = TextEditingController();

  final imageBaseURl = "https://image.tmdb.org/t/p/original";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            height: 120,
            color: bgWhite,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 25, 25, 0),
              child: BlocBuilder<MoviesCubit, MoviesState>(
                builder: (context, state) {
                  if (state is SearchResultShowedState) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            BlocProvider.of<MoviesCubit>(context).closeSearch();
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        Text(
                          '${state.movies.length} Results Found',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<MoviesCubit, MoviesState>(
                        builder: (context, state) {
                          if (state is SearchClosedState ||
                              state is MoviesLoadedState) {
                            return const Text(
                              'Watch',
                              style: TextStyle(fontSize: 20),
                            );
                          }
                          return Container();
                        },
                      ),
                      Expanded(
                        child: SearchBarAnimation(
                          searchBoxBorderColour: bgGrey,
                          textEditingController: _searchController,
                          isOriginalAnimation: false,
                          enableKeyboardFocus: false,
                          searchBoxColour: bgGrey,
                          isSearchBoxOnRightSide: true,
                          enableButtonBorder: false,
                          cursorColour: blue,
                          hintText: 'TV Shows, Movies, and More',
                          durationInMilliSeconds: 500,
                          onEditingComplete: () {
                            _searchController = TextEditingController();
                            BlocProvider.of<MoviesCubit>(context)
                                .searchComplete();
                          },
                          onChanged: (value) {
                            if (value.toString().length > 2) {
                              BlocProvider.of<MoviesCubit>(context)
                                  .searchMovies(value);
                            }
                          },
                          onPressButton: (isOpen) {
                            _searchController = TextEditingController();
                            BlocProvider.of<MoviesCubit>(context).openSearch();
                          },
                          onCollapseComplete: () {
                            BlocProvider.of<MoviesCubit>(context).closeSearch();
                          },
                          trailingWidget: const Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.black,
                          ),
                          secondaryButtonWidget: const Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.black,
                          ),
                          buttonWidget: const Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          BlocBuilder<MoviesCubit, MoviesState>(
            builder: (context, state) {
              if (state is ShowSearchResultState) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 20.0),
                      Text(
                        'Top Results',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10.0),
                      Divider(
                        color: Colors.grey,
                        height: 1,
                        thickness: 1,
                      )
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
          BlocBuilder<MoviesCubit, MoviesState>(
            builder: (context, state) {
              if (state is MoviesLoadedState) {
                return buildMoviesList(state.movies);
              }

              if (state is SearchClosedState) {
                return buildMoviesList(state.movies);
              }

              if (state is SearchOpenedState) {
                return buildMoviesList(state.movies);
              }

              if (state is ShowSearchResultState) {
                return buildSearchList(state.movies);
              }

              if (state is SearchResultShowedState) {
                return buildSearchList(state.movies);
              }

              if (state is MoviesLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              return Container();
            },
          ),
        ],
      ),
    );
  }

  Widget buildSearchList(List<Movie> movies) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 2.5,
        ),
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          var movie = movies[index];
          return SearchCard(
            title: movie.originalTitle,
            icon: (movie.posterPath.isEmpty)
                ? "https://propertywiselaunceston.com.au/wp-content/themes/property-wise/images/no-image.png"
                : imageBaseURl + movie.posterPath,
            genre: "Nill",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailsScreen(
                    movieId: movie.id.toString(),
                  ),
                ),
              );
            },
          );
        },
        itemCount: movies.length,
        scrollDirection: Axis.vertical,
      ),
    );
  }

  Widget buildMoviesList(List<Movie> movies) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1.7,
      ),
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        var movie = movies[index];
        return MovieCard(
          title: movie.originalTitle,
          icon: (movie.posterPath.isEmpty)
              ? "https://propertywiselaunceston.com.au/wp-content/themes/property-wise/images/no-image.png"
              : imageBaseURl + movie.posterPath,
          press: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailsScreen(
                  movieId: movie.id.toString(),
                ),
              ),
            );
          },
        );
      },
      itemCount: movies.length,
      scrollDirection: Axis.vertical,
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.press,
  }) : super(key: key);

  final String icon, title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              SizedBox(
                width: double.infinity,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: icon,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchCard extends StatelessWidget {
  const SearchCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.genre,
    required this.press,
  }) : super(key: key);

  final String icon, title, genre;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              child: SizedBox(
                width: 180,
                height: 120,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: icon,
                ),
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    genre,
                    style: const TextStyle(
                      color: textLightGrey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
