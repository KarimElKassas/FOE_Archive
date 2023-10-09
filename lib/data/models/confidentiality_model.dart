import 'package:foe_archive/domain/entities/confidentiality.dart';

class ConfidentialityModel extends Confidentiality{
  ConfidentialityModel(super.confidentialityId, super.confidentialityName);

  factory ConfidentialityModel.fromJson(Map<String, dynamic> json){
    return ConfidentialityModel(
        int.parse(json['confidentialityId'].toString()),
        json['confidentialityName']);
  }

  Map<String, dynamic> toJson() => {
    'confidentialityId': confidentialityId,
    'confidentialityName': confidentialityName,
  };
}