import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tropipay_test_movie_app/src/models/movie_model.dart';
import 'package:tropipay_test_movie_app/src/controllers/movies_controller.dart';
import 'package:tropipay_test_movie_app/src/search/search_delegate.dart';
import 'package:tropipay_test_movie_app/src/widgets/list_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final MoviesController controller = Get.find<MoviesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Películas',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey[800],
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: DataSearch(),
                );
              },
            )
          ],
        ),
        body: _movieList());
  }

  _movieList() {
    return FutureBuilder(
        future: controller.getPopular(),
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return MyList(nextPage: controller.getPopular);
          } else {
            return const SizedBox(
                height: 300.0,
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }
}
