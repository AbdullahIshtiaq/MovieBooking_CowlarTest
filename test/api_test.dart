import 'package:cowlar_entry_test_app/data/repo/movie_repo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("API Testing", () {
    test('Fetch Movies API', () async {
      bool result = false;
      MovieRepository movieRepository = MovieRepository();

      var fetchMovies = (await movieRepository.fetchMovies());
      if (fetchMovies.isNotEmpty) {
        result = true;
      }
      expect(result, true);
    });

    test('Fetch Movie By ID API', () async {
      bool result = false;
      MovieRepository movieRepository = MovieRepository();

      var fetchMovieByID = (await movieRepository.fetchMovieByID("4567"));
      if (fetchMovieByID != null) {
        result = true;
      }
      expect(result, true);
    });

    test('Search Movies API', () async {
      bool result = false;
      MovieRepository movieRepository = MovieRepository();

      var searchMovies = (await movieRepository.searchMovies("Batman"));
      if (searchMovies.isNotEmpty) {
        result = true;
      }
      expect(result, true);
    });

    test('Fetch Movie Videos API', () async {
      bool result = false;
      MovieRepository movieRepository = MovieRepository();

      var fetchMovieVideos = (await movieRepository.fetchMovieVideos("4567"));

      if (fetchMovieVideos != null) {
        result = true;
      }
      expect(result, true);
    });
  });
}
