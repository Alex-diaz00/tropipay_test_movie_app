import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tropipay_test_movie_app/src/controllers/movies_controller.dart';

class MyList extends StatelessWidget {
  final MoviesController controller = Get.find<MoviesController>();
  final Function nextPage;

  MyList({super.key, required this.nextPage});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Obx(() => NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              controller.getPopular();
            }
            return false;
          },
          child: ListView.builder(
              itemCount: controller.topRated.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: FadeInImage(
                    image: controller.topRated[index].getPosterImg() != null
                        ? NetworkImage(
                            controller.topRated[index].getPosterImg())
                        : const AssetImage('assets/img/no-image.jpg'),
                    placeholder: const AssetImage('assets/img/no-image.jpg'),
                    height: 200,
                    fit: BoxFit.fill,
                  ),
                  visualDensity: const VisualDensity(vertical: 4),
                  title: Text(controller.topRated[index].title),
                  subtitle: Wrap(
                    children: [
                      Text(
                        controller.topRated[index].overview,
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                      Text(controller.topRated[index].releaseDate),
                      Row(
                        children: [
                          const Icon(Icons.star),
                          Text(controller.topRated[index].voteAverage
                              .toStringAsFixed(1))
                        ],
                      )
                    ],
                  ),
                  onTap: () async => Navigator.pushNamed(context, 'detail',
                      arguments: controller.topRated[index]),
                );
              }))),
      Obx(() => _loading()),
    ]);
  }

  Widget _loading() {
    if (controller.loading) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: CircularProgressIndicator(),
              ),
            ],
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
