class MovieVideos {
  MovieVideos({
    required this.id,
    required this.results,
  });
  late final int id;
  late final List<Results> results;

  MovieVideos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    results =
        List.from(json['results']).map((e) => Results.fromJson(e)).toList();
  }
}

class Results {
  Results({
    required this.name,
    required this.key,
    required this.site,
    required this.id,
  });

  late final String name;
  late final String key;
  late final String site;
  late final String id;

  Results.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    key = json['key'];
    site = json['site'];
    id = json['id'];
  }
}
