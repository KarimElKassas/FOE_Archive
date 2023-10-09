import 'package:foe_archive/domain/entities/necessary.dart';

class NecessaryModel extends Necessary{
  NecessaryModel(super.necessaryId, super.necessaryName);

  factory NecessaryModel.fromJson(Map<String, dynamic> json){
    return NecessaryModel(
        int.parse(json['necessaryId'].toString()),
        json['necessaryName']);
  }

  Map<String, dynamic> toJson() => {
    'necessaryId': necessaryId,
    'necessaryName': necessaryName,
  };
}