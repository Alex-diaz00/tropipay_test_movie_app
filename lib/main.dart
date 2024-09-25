import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'package:tropipay_test_movie_app/src/controllers/movies_controller.dart';
import 'package:tropipay_test_movie_app/src/pages/home_page.dart';
import 'package:tropipay_test_movie_app/src/pages/movie_detail_page.dart';

void main() async {
  Get.lazyPut<MoviesController>(() => MoviesController());
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Películas',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'detail': (BuildContext context) => const MovieDetailPage(),
      },
    );
  }
}
