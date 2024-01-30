class CryptoNewsLive {
  String? status;
  int? totalResults;
  List<Articles>? articles;

  CryptoNewsLive({this.status, this.totalResults, this.articles});

  CryptoNewsLive.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? "";
    totalResults = json['totalResults'] ?? 0;
    if (json['articles'] != null) {
      articles = [];
      json['articles'].forEach((v) {
        articles!.add(new Articles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalResults'] = this.totalResults;
    if (this.articles != null) {
      data['articles'] = this.articles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Articles {
  late Source source;
  String author = "";
  String title = "";
  String description = "";
  String url = "";
  String urlToImage = "";
  String publishedAt = "";
  String content = "";

  Articles({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  Articles.fromJson(Map<String, dynamic> json) {
    source = (json['source'] != null ? new Source.fromJson(json['source']) : null)!;
    author = json['author'] ?? "";
    title = json['title'] ?? "";
    description = json['description'] ?? "";
    url = json['url'] ?? "";
    urlToImage = json['urlToImage'] ?? "";
    publishedAt = json['publishedAt'] ?? "";
    content = json['content'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // ignore: unnecessary_null_comparison
    if (this.source != null) {
      data['source'] = this.source.toJson();
    }
    data['author'] = this.author;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['urlToImage'] = this.urlToImage;
    data['publishedAt'] = this.publishedAt;
    data['content'] = this.content;
    return data;
  }
}

class Source {
  String id = "";
  String name = "";

  Source({required this.id, required this.name});

  Source.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
