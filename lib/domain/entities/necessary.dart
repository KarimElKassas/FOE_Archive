import 'package:equatable/equatable.dart';

class Necessary extends Equatable{

  int necessaryId;
  String necessaryName;

  Necessary(this.necessaryId, this.necessaryName);

  @override
  List<Object?> get props => [
    necessaryId, necessaryName
  ];

}