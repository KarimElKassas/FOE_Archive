import 'package:equatable/equatable.dart';

class Sector extends Equatable{

  int sectorId;
  String sectorName;

  Sector(this.sectorId, this.sectorName);

  @override
  List<Object?> get props => [
    sectorId, sectorName
  ];

}