import 'dart:convert';
import 'package:cowlar_entry_test_app/data/model/movie_model.dart';
import 'package:cowlar_entry_test_app/data/model/movie_video_model.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class MovieRepository {
  final String _apiKey = "?api_key=469fe4e612edc74e7c46b42641ac9287";
  final String _baseUrl = "https://api.themoviedb.org/3/movie/";

  static final _client = http.Client();

  final Map<String, String> _requestHeaders = {
    'Content-Type': 'application/json',
  };

  Future<List<Movie>> fetchMovies() async {
    try {
      var url = Uri.parse("${_baseUrl}upcoming$_apiKey");
      Response response = await _client.get(url, headers: _requestHeaders);

      if (response.statusCode == 200) {
        List<dynamic> movieMaps = jsonDecode(response.body)['results'];
        return movieMaps.map((movieMap) => Movie.fromJson(movieMap)).toList();
      } else {
        return [];
      }
    } catch (ex) {
      rethrow;
    }
  }

  Future<Movie?> fetchMovieByID(String movieId) async {
    try {
      var url = Uri.parse("$_baseUrl$movieId$_apiKey");
      Response response = await _client.get(url, headers: _requestHeaders);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return Movie.fromJson(data);
      } else {
        return null;
      }
    } catch (ex) {
      rethrow;
    }
  }

  Future<List<Movie>> searchMovies(String word) async {
    try {
      var baseUrl = "https://api.themoviedb.org/3/search/movie";
      var url = Uri.parse("$baseUrl$_apiKey&query=$word");

      Response response = await _client.get(url, headers: _requestHeaders);

      if (response.statusCode == 200) {
        List<dynamic> movieMaps = jsonDecode(response.body)['results'];
        return movieMaps.map((movieMap) => Movie.fromJson(movieMap)).toList();
      } else {
        return [];
      }
    } catch (ex) {
      rethrow;
    }
  }

  Future<MovieVideos?> fetchMovieVideos(String movieId) async {
    try {
      var url = Uri.parse("$_baseUrl$movieId/videos$_apiKey");
      print(url);
      Response response = await _client.get(url, headers: _requestHeaders);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return MovieVideos.fromJson(data);
      } else {
        return null;
      }
    } catch (ex) {
      rethrow;
    }
  }
}
