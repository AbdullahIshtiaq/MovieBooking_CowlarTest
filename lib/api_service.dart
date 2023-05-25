import 'dart:convert';

import 'package:cowlar_entry_test_app/model/movie.dart';
import 'package:cowlar_entry_test_app/model/movie_video.dart';
import 'package:http/http.dart' as http;

import 'model/movies_collection.dart';

import 'dart:developer' as developer;

class APIService {
  static var client = http.Client();

  static Future<MoviesCollection?> getMovies() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    String apiKey = "?api_key=469fe4e612edc74e7c46b42641ac9287";

    var url = Uri.parse("https://api.themoviedb.org/3/movie/upcoming$apiKey");

    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      //developer.log('log me 27: $data', name: 'my.app.movies');
      return MoviesCollection.fromJson(data);
    } else {
      print("Response 28: Failed");
      return null;
    }
  }

  static Future<MoviesCollection?> searchMovie(String word) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    String apiKey =
        "?api_key=469fe4e612edc74e7c46b42641ac9287&query=$word&append_to_response=genres";

    var url = Uri.parse("https://api.themoviedb.org/3/search/movie$apiKey");

    print("Url 45: $url");

    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      //developer.log('log me 50: $data', name: 'my.app.movies');
      return MoviesCollection.fromJson(data);
    } else {
      print("Response 52: Failed");
      return null;
    }
  }

  static Future<Movie?> getMovieByID(String movieId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    String apiKey = "/$movieId?api_key=469fe4e612edc74e7c46b42641ac9287";

    var url = Uri.parse("https://api.themoviedb.org/3/movie$apiKey");

    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      //developer.log('log me 71: $data', name: 'my.app.movies');
      return Movie.fromJson(data);
    } else {
      print("Response 74: Failed");
      return null;
    }
  }

  static Future<MovieVideo?> getMovieVideos(String movieId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    String apiKey = "/$movieId/videos?api_key=469fe4e612edc74e7c46b42641ac9287";

    var url = Uri.parse("https://api.themoviedb.org/3/movie$apiKey");

    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // developer.log('log me 92: $data', name: 'my.app.movies');
      return MovieVideo.fromJson(data);
    } else {
      print("Response 95: Failed");
      return null;
    }
  }
}
