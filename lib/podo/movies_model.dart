class MovieModel {
  String title, year, posterUrl;

  MovieModel({this.title, this.year, this.posterUrl});

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
        title: json["Title"], year: json["Year"], posterUrl: json["Poster"]);
  }
}
