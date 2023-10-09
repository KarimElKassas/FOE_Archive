import 'package:equatable/equatable.dart';

class Confidentiality extends Equatable{

  int confidentialityId;
  String confidentialityName;

  Confidentiality(this.confidentialityId, this.confidentialityName);

  @override
  List<Object?> get props => [
    confidentialityId, confidentialityName
  ];

}