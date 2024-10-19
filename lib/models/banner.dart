class Banner {
  final int id;
  final String cover;
  final String? title;
  final String? description;
  final int isActive;
  final int position;

  Banner({
    required this.id,
    required this.cover,
    this.title,
    this.description,
    required this.isActive,
    required this.position,
  });

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      id: json['id'],
      cover: json['cover'],
      title: json['title'],
      description: json['description'],
      isActive: json['is_active'],
      position: json['position'],
    );
  }
}
