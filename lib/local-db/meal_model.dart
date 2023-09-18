class MealModel {
  final String? id;
  final String? title;
  final bool? isCompleted;

  MealModel({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  MealModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        title = json['title'] as String?,
        isCompleted = json['is_completed'] as bool?;

  Map<String, dynamic> toJson() => {"id": id, "title": title, "is_completed": isCompleted};

  @override
  String toString() {
    return """
      {
        id: $id,
        title: $title,
        is_completed: $isCompleted
      }
    """;
  }
}
