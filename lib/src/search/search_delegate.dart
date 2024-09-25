import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tropipay_test_movie_app/src/models/movie_model.dart';
import 'package:tropipay_test_movie_app/src/controllers/movies_controller.dart';

class DataSearch extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Buscar';

  final MoviesController controller = Get.find<MoviesController>();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: controller.searchMovie(query),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error en la búsqueda: ${snapshot.error}'));
        } else if (snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay resultados'));
        } else {
          final movies = snapshot.data;

          return ListView(
              children: movies!.map((movie) {
            return ListTile(
              leading: FadeInImage(
                image: movie.getPosterImg() != null
                    ? NetworkImage(movie.getPosterImg())
                    : const AssetImage('assets/img/no-image.jpg'),
                placeholder: const AssetImage('assets/img/no-image.jpg'),
                width: 50.0,
                fit: BoxFit.contain,
              ),
              title: Text(movie.title),
              onTap: () {
                close(context, null);
                Navigator.pushNamed(context, 'detail', arguments: movie);
              },
            );
          }).toList());
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
