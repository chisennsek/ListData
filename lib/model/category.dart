class CategoriesResponse {
  String slug;
  String name;
  String url;

  CategoriesResponse({
    required this.slug,
    required this.name,
    required this.url,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) =>
      CategoriesResponse(
        slug: json["slug"],
        name: json["name"],
        url: json["url"],
      );
}
