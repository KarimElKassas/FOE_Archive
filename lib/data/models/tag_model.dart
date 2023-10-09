import '../../domain/entities/tag.dart';

class TagModel extends Tag{
  TagModel(super.tagId, super.tagName);

  factory TagModel.fromJson(Map<String, dynamic> json){
    return TagModel(
        int.parse(json['tagId'].toString()),
        json['tagName']);
  }

  Map<String, dynamic> toJson() => {
    'tagId': tagId,
    'tagName': tagName,
    'display':tagName
  };
  Map<String, dynamic> toMention() => {
    'id': tagId.toString(),
    'title': tagName,
    'subtitle': "",
    'imageURL': ""
  };
}