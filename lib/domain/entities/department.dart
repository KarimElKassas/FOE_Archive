import 'package:equatable/equatable.dart';

class Department extends Equatable{

  int departmentId;
  String departmentName;
  int sectorId;

  Department(this.departmentId, this.departmentName,this.sectorId);

  @override
  List<Object?> get props => [
    departmentId, departmentName, sectorId
  ];

}