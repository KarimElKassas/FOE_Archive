import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class User extends Equatable{
  @HiveField(0)
  int userId;
  @HiveField(1)
  String userName;
  @HiveField(2)
  String userPassword;
  @HiveField(3)
  int departmentId;
  @HiveField(4)
  int roleId;

  User(this.userId, this.userName, this.userPassword, this.departmentId, this.roleId);

  @override
  List<Object?> get props => [
    userId, userName, userPassword, departmentId, roleId
  ];

}