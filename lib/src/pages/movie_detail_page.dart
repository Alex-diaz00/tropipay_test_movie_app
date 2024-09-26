import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tropipay_test_movie_app/src/controllers/movies_controller.dart';
import 'package:tropipay_test_movie_app/src/models/movie_model.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final movie = ModalRoute.of(context)!.settings.arguments as Movie;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _appbar(movie),
          SliverToBoxAdapter(
            child: Column(
              children: [
                FutureBuilder(
                    future: _showDetails(context, movie),
                    builder:
                        (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                            height: size.height * 0.3,
                            child: const Center(
                                child: CircularProgressIndicator()));
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                'Error obteniendo datos: ${snapshot.error}'));
                      } else {
                        return snapshot.data!;
                      }
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _appbar(Movie movie) {
    return SliverAppBar(
      iconTheme: const IconThemeData(
        color: Colors.white, //change your color here
      ),
      elevation: 2.0,
      backgroundColor: Colors.grey[800],
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          movie.title,
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: movie.getBackgroundImg() != null
              ? NetworkImage(movie.getBackgroundImg())
              : const AssetImage('assets/img/no-image.jpg'),
          placeholder: const AssetImage('assets/img/loading.gif'),
          fadeInDuration: const Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<Widget> _showDetails(BuildContext context, Movie m) async {
    final MoviesController controller = Get.find<MoviesController>();
    final movie = await controller.movieDetail(m.id);
    int hours = movie.runtime ~/ 60;
    int minutes = movie.runtime % 60;
    List<Widget> genres = [];

    for (var element in movie.genres) {
      final string = element['name'];
      final widget = Chip(
        label: Text(string),
        visualDensity: const VisualDensity(vertical: -4),
      );
      genres.add(widget);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image(
                  image: movie.getPosterImg() != null
                      ? NetworkImage(movie.getPosterImg())
                      : const AssetImage('assets/img/no-image.jpg'),
                  height: 150.0,
                ),
              ),
              const SizedBox(width: 20.0),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      movie.title,
                    ),
                    Text('Duración: $hours h: $minutes m'),
                    Row(
                      children: <Widget>[
                        const Icon(Icons.star),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                        ),
                      ],
                    ),
                    const Text('Géneros:'),
                    Wrap(
                      spacing: 5.0, // spacing between adjacent chips
                      runSpacing: 5.0,
                      children: genres,
                    ),
                  ],
                ),
              )
            ],
          ),
          _descripcion(movie),
        ],
      ),
    );
  }

  Widget _descripcion(Movie movie) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }
}
