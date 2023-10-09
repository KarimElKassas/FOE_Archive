import 'package:equatable/equatable.dart';

class Direction extends Equatable{

  int directionId;
  String directionName;

  Direction(this.directionId, this.directionName);

  @override
  List<Object?> get props => [
    directionId, directionName
  ];

}