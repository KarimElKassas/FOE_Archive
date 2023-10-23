import 'package:foe_archive/domain/entities/user.dart';
import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends User{
  UserModel(
      @HiveField(0)
      super.userId,
      @HiveField(1)
      super.userName,
      @HiveField(2)
      super.userPassword,
      @HiveField(3)
      super.departmentId,
      @HiveField(4)
      super.roleId);

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