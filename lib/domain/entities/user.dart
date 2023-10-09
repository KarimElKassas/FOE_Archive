import 'package:equatable/equatable.dart';

class User extends Equatable{

  int userId;
  String userName;
  String userPassword;
  int departmentId;
  int roleId;

  User(this.userId, this.userName, this.userPassword, this.departmentId, this.roleId);

  @override
  List<Object?> get props => [
    userId, userName, userPassword, departmentId, roleId
  ];

}