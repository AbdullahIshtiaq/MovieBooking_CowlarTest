import 'package:cached_network_image/cached_network_image.dart';
import 'package:cowlar_entry_test_app/api_service.dart';
import 'package:cowlar_entry_test_app/constants.dart';
import 'package:cowlar_entry_test_app/model/movies_collection.dart';
import 'package:flutter/material.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

import '../floor_db/database.dart';
import '../floor_db/movie_dao.dart';
import '../floor_db/movie_entity.dart';
import 'movie_screen.dart';

class WatchScreen extends StatefulWidget {
  const WatchScreen({super.key});

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  bool isSearching = false;
  bool isLoading = false;
  bool isSearchVisible = false;
  bool showResults = false;
  final List<Results> items = [];
  final List<Results> searchItems = [];

  late AppDatabase database;
  late MovieDao movieDao;

  TextEditingController _searchController = TextEditingController();

  final imageBaseURl = "https://image.tmdb.org/t/p/original";

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    getMovies();

    updateMoviesData();

    super.initState();
  }

  void getMovies() async {
    database = await $FloorAppDatabase.databaseBuilder('movies.db').build();
    movieDao = database.movieDao;

    List<MovieEntity> moviesList = await movieDao.getAllMovies();

    if (moviesList.isNotEmpty) {
      moviesList.forEach((element) {
        items.add(
          Results(
            genreIds:
                element.genreIds.split(",").map((e) => int.parse(e)).toList(),
            id: element.id,
            originalTitle: element.title,
            overview: element.overview,
            posterPath: element.posterPath,
            backdropPath: element.backdropPath,
            releaseDate: element.releaseDate,
            title: element.title,
            movieGenre: element.genre,
          ),
        );
      });
      setState(() {
        isLoading = false;
      });
    } else {
      final apiResponse = await APIService.getMovies() as MoviesCollection;

      final movies = apiResponse.results
          .map(
            (result) => MovieEntity(
              id: result.id,
              title: result.title,
              overview: result.overview,
              posterPath: result.posterPath,
              releaseDate: result.releaseDate,
              backdropPath: result.backdropPath,
              genreIds: result.genreIds.map((e) => e).join(","),
            ),
          )
          .toList();

      await movieDao.insertMovies(movies);
      items.addAll(apiResponse.results);
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchMovie(searchWord) async {
    await APIService.searchMovie(searchWord).then((response) => {
          if (response != null)
            {
              searchItems.clear(),
              response.results.forEach((element) {
                getMovieGenre(element);
                searchItems.add(element);
              }),
              setState(() {
                isSearchVisible = true;
                isLoading = false;
              })
            }
        });
  }

  void getMovieGenre(Results movieItem) async {
    var apiResponse = await APIService.getMovieByID(movieItem.id.toString());
    if (apiResponse != null) {
      if (apiResponse.genres.isNotEmpty) {
        movieItem.movieGenre = apiResponse.genres[0].name;
      } else {
        movieItem.movieGenre = "Nill";
      }
    }
  }

  void updateMoviesData() async {
    final apiResponse = await APIService.getMovies() as MoviesCollection;

    final movies = apiResponse.results
        .map(
          (result) => MovieEntity(
            id: result.id,
            title: result.title,
            overview: result.overview,
            posterPath: result.posterPath,
            releaseDate: result.releaseDate,
            backdropPath: result.backdropPath,
            genreIds: result.genreIds.map((e) => e).join(","),
          ),
        )
        .toList();

    await movieDao.deleteAllMovies();
    await movieDao.insertMovies(movies);
  }

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
              child: (!showResults)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (!isSearching)
                            ? const Text(
                                'Watch',
                                style: TextStyle(fontSize: 20),
                              )
                            : Container(),
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
                            onEditingComplete: () {
                              setState(() {
                                _searchController = TextEditingController();
                                showResults = true;
                                isSearchVisible = false;
                                isSearching = false;
                              });
                            },
                            onChanged: (value) {
                              if (value.toString().length > 2) {
                                setState(() {
                                  isLoading = true;
                                });
                                searchMovie(value);
                              }
                            },
                            onPressButton: (isOpen) {
                              setState(() {
                                isSearching = true;
                              });
                            },
                            onCollapseComplete: () {
                              setState(() {
                                _searchController.clear();
                                isSearchVisible = false;
                                isSearching = false;
                              });
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
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              showResults = false;
                              isSearchVisible = false;
                              isSearching = false;
                              searchItems.clear();
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        Text(
                          '${searchItems.length} Results Found',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
            ),
          ),
          (isSearchVisible)
              ? Padding(
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
                )
              : Container(),
          (!isLoading)
              ? (!isSearchVisible && !showResults)
                  ? GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 1.7,
                      ),
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) => MovieCard(
                        title: items[index].originalTitle,
                        icon: (items[index].posterPath.isEmpty)
                            ? "https://propertywiselaunceston.com.au/wp-content/themes/property-wise/images/no-image.png"
                            : imageBaseURl + items[index].posterPath,
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailsScreen(
                                movieId: items[index].id.toString(),
                              ),
                            ),
                          );
                        },
                      ),
                      itemCount: items.length,
                      scrollDirection: Axis.vertical,
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 2.5,
                        ),
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) => SearchCard(
                          title: searchItems[index].originalTitle,
                          icon: (searchItems[index].posterPath.isEmpty)
                              ? "https://propertywiselaunceston.com.au/wp-content/themes/property-wise/images/no-image.png"
                              : imageBaseURl + searchItems[index].posterPath,
                          genre: searchItems[index].movieGenre.toString(),
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailsScreen(
                                  movieId: searchItems[index].id.toString(),
                                ),
                              ),
                            );
                          },
                        ),
                        itemCount: searchItems.length,
                        scrollDirection: Axis.vertical,
                      ),
                    )
              : const Center(child: CircularProgressIndicator()),
        ],
      ),
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
