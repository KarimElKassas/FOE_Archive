import 'package:foe_archive/domain/entities/department.dart';
class DepartmentModel extends Department{
  DepartmentModel(super.departmentId, super.departmentName, super.sectorId);

  factory DepartmentModel.fromJson(Map<String, dynamic> json){
    return DepartmentModel(
        int.parse(json['departmentId'].toString()),
        json['departmentName'],
        int.parse(json['sectorId'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'departmentId': departmentId,
    'departmentName': departmentName,
    'sectorId': sectorId,
  };

}