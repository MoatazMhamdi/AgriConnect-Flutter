class Equipment {
  final String id;
  final String name;
  final String image;
  final String category;
  final String description;
  final String condition;
  final String userId;
  final int version;

  Equipment({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.description,
    required this.condition,
    required this.userId,
    required this.version,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['_id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      category: json['categorie'] as String,
      description: json['description'] as String,
      condition: json['etat'] as String,
      userId: json['userId'] as String,
      version: json['__v'] as int,
    );
  }

}
