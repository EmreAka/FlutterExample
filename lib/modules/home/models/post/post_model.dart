import 'package:flutter_example/core/models/model_interface.dart';

class PostModel implements IModel<PostModel> {
  final int id;

  final String title;

  final String body;

  PostModel({
    required this.id,
    required this.title,
    required this.body,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }

  @override
  PostModel fromJson(Map<String, Object?> json) => PostModel.fromJson(json);
}
