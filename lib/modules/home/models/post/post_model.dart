import 'package:flutter_example/core/models/model_interface.dart';
import 'package:flutter_example/shared/constants/hive_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'post_model.g.dart';

@HiveType(typeId: HiveConstants.postTypeId)
class PostModel implements IModel<PostModel>{
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
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
