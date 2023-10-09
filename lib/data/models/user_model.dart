import 'package:foe_archive/domain/entities/user.dart';

class UserModel extends User{
  UserModel(super.userId, super.userName, super.userPassword, super.departmentId, super.roleId);

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
        int.parse(json['userId'].toString()),
        json['userHandle'],
        json['password'],
        int.parse(json['departmentId'].toString()),
        int.parse(json['roleId'].toString()));
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'userHandle': userName,
    'password': userPassword,
    'departmentId': departmentId,
    'roleId': roleId,
  };

}