import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'dart:convert';


import 'package:tropipay_test_movie_app/src/models/movie_model.dart';

class MoviesController extends GetxController {
  final _topRatedPage = RxInt(0);
  final _loading = RxBool(false);
  bool get loading => _loading.value;

  final RxList<Movie> _topRated = RxList();

  RxList<Movie> get topRated => _topRated;

  Future<List<Movie>> _processResponse(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final movies = Movies.fromJsonList(decodedData['results']);

    return movies.items;
  }

  Future<List<Movie>> getPopular() async {
    if (_loading.value) return [];

    _loading.value = true;
    _topRatedPage.value++;

    final url = Uri.https(dotenv.env['URL']!, dotenv.env['POPULAR_ENDPOINT']!, {
      'api_key': dotenv.env['APIKEY'],
      'language': dotenv.env['LANGUAGE'],
      'page': _topRatedPage.toString(),
      'Connection': "Keep-Alive",
    });

    final resp = await _processResponse(url);

    _topRated.addAll(resp);

    _loading.value = false;
    return _topRated;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(dotenv.env['URL']!, dotenv.env['SEARCH_ENDPOINT']!, {
      'api_key': dotenv.env['APIKEY'],
      'language': dotenv.env['LANGUAGE'],
      'query': query
    });
    return await _processResponse(url);
  }

  Future<MovieDetail> movieDetail(int id) async {
    final url = Uri.https(
        dotenv.env['URL']!, '${dotenv.env['MOVIE_DETAIL_ENDPOINT']!}/$id', {
      'api_key': dotenv.env['APIKEY'],
      'language': dotenv.env['LANGUAGE'],
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final movies = MovieDetail.fromJsonMap(decodedData);
    return movies;
  }
}
