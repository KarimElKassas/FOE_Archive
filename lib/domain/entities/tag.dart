import 'package:equatable/equatable.dart';

class Tag extends Equatable{

  int tagId;
  String tagName;

  Tag(this.tagId, this.tagName);

  @override
  List<Object?> get props => [
    tagId, tagName
  ];

}