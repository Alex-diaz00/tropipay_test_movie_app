class Movies {
  List<Movie> items = List.empty(growable: true);

  Movies();

  Movies.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      final movie = Movie.fromJsonMap(item);
      items.add(movie);
    }
  }
}

class Movie {
  late int voteCount;
  late int id;
  late double voteAverage;
  late String title;
  late String? posterPath;
  late String? backdropPath;
  late String overview;
  late String releaseDate;

  Movie({
    voteCount,
    id,
    video,
    voteAverage,
    title,
    popularity,
    posterPath,
    originalLanguage,
    originalTitle,
    backdropPath,
    adult,
    overview,
    releaseDate,
  });

  Movie.fromJsonMap(Map<String, dynamic> json) {
    voteCount = json['vote_count'];
    id = json['id'];
    voteAverage = json['vote_average'] / 1;
    title = json['title'];
    posterPath = json['poster_path'] as String?;
    backdropPath = json['backdrop_path'] as String?;
    overview = json['overview'];
    releaseDate = json['release_date'];
  }

  getPosterImg() {
    if (posterPath != null) {
      return 'https://image.tmdb.org/t/p/w500$posterPath';
    }
    return null;
  }

  getBackgroundImg() {
    if (backdropPath != null) {
      return 'https://image.tmdb.org/t/p/w500$backdropPath';
    }
    return null;
  }
}

class MovieDetail extends Movie {
  late int runtime;
  late List genres;

  MovieDetail.fromJsonMap(Map<String, dynamic> json) : super.fromJsonMap(json) {
    runtime = json['runtime'];
    genres = json['genres'];
  }
}
