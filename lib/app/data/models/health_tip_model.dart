class HealthTipModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final String icon;
  final String image;

  HealthTipModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.image,
  });

  factory HealthTipModel.fromJson(Map<String, dynamic> json) {
    return HealthTipModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'] ?? 'Umum',
      icon: json['icon'],
      image: json['image'],
    );
  }
}
