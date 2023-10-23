import 'package:equatable/equatable.dart';

class Letter extends Equatable{

  int letterId;
  String letterAbout;
  String letterContent;
  dynamic letterDate;
  String letterNumber;
  int previousLetterId;
  int confidentialityId;
  int necessaryId;
  int directionId;
  int createdBy;
  bool hasReply;
  int departmentId;
  int? deletedBy;
  dynamic deletedAt;
  int? updatedBy;
  dynamic updatedAt;

  Letter(
      this.letterId,
      this.letterAbout,
      this.letterContent,
      this.letterDate,
      this.letterNumber,
      this.previousLetterId,
      this.confidentialityId,
      this.necessaryId,
      this.directionId,
      this.createdBy,
      this.hasReply,
      this.departmentId,
      this.deletedBy,
      this.deletedAt,
      this.updatedBy,
      this.updatedAt
      );

  @override
  List<Object?> get props => [
    letterId,letterAbout,letterContent,letterDate,letterNumber,previousLetterId,confidentialityId,necessaryId,directionId,createdBy,hasReply,departmentId
  ];
}