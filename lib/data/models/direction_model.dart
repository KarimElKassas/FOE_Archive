import 'package:foe_archive/domain/entities/direction.dart';

class DirectionModel extends Direction{
  DirectionModel(super.directionId, super.directionName);

  factory DirectionModel.fromJson(Map<String, dynamic> json){
    return DirectionModel(
        int.parse(json['directionId'].toString()),
        json['directionName']);
  }

  Map<String, dynamic> toJson() => {
    'directionId': directionId,
    'directionName': directionName,
  };

}