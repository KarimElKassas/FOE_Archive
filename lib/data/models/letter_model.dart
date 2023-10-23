import 'package:easy_localization/easy_localization.dart';
import 'package:foe_archive/domain/entities/letter.dart';
import 'package:foe_archive/resources/constants_manager.dart';
import 'package:hive/hive.dart';

import '../../resources/strings_manager.dart';
part 'letter_model.g.dart';
@HiveType(typeId: 2)
class LetterModel extends Letter{
  LetterModel(
      @HiveField(0)
      super.letterId,
      @HiveField(1)
      super.letterAbout,
      @HiveField(2)
      super.letterContent,
      @HiveField(3)
      super.letterDate,
      @HiveField(4)
      super.letterNumber,
      @HiveField(5)
      super.previousLetterId,
      @HiveField(6)
      super.confidentialityId,
      @HiveField(7)
      super.necessaryId,
      @HiveField(8)
      super.directionId,
      @HiveField(9)
      super.createdBy,
      @HiveField(10)
      super.hasReply,
      @HiveField(11)
      super.departmentId,
      @HiveField(12)
      super.deletedBy,
      @HiveField(13)
      super.deletedAt,
      @HiveField(14)
      super.updatedBy,
      @HiveField(15)
      super.updatedAt,
      @HiveField(16)
      this.filesList,
      @HiveField(17)
      this.directionName,
      @HiveField(18)
      this.letterReplyId,
      @HiveField(19)
      this.letterTags,
      @HiveField(20)
      this.letterMentions,
      @HiveField(21)
      this.departmentLetters,
      @HiveField(22)
      this.repliesOnLetterCount,
      @HiveField(23)
      this.repliesLetters);
  List<FilesList>? filesList;
  List<LetterTags>? letterTags;
  List<LetterMentions>? letterMentions;
  List<DepartmentLetters> departmentLetters;
  List<LetterModel>? repliesLetters;
  int? letterReplyId;
  String directionName;
  int? repliesOnLetterCount;

  factory LetterModel.fromJson(Map<String, dynamic> json){
    return LetterModel(
        int.parse(json['letterId'].toString()),
        json['letterAbout'],
        json['letterContent'],
        json['letterDate'] ?? json['updatedAt'],
        json['letterNumber'],
        json['previousLetterId'] == null ? 0 : int.parse(json['previousLetterId'].toString()),
        int.parse(json['confidentialityId'].toString()),
        int.parse(json['necessaryId'].toString()),
        json['direction'] == null ? 0 : int.parse(json['direction']['directionId'].toString()),
        int.parse(json['createdBy'].toString()),
        json['hasReply'] ?? false,
        int.parse(json['departmentId'].toString()),
        json['deletedBy'] == null ? 0 : int.parse(json['deletedBy'].toString()),
        json['deletedAt'],
        json['updatedBy'] == null ? 0 : int.parse(json['updatedBy'].toString()),
        json['updatedAt'],
        json['files'] != null
          ? (json['files'] as List<dynamic>).map((e) => FilesList.fromJson(e as Map<String, dynamic>)).toList()
          : null,
      json['direction'] == null ? AppStrings.notFound.tr() : json['direction']['directionName'],
      json['letterReplyId'] == null ? 0 : int.parse(json['letterReplyId'].toString()),
      json['tags'] != null
          ? (json['tags'] as List<dynamic>).map((e) => LetterTags.fromJson(e as Map<String, dynamic>)).toList()
          : null,
      json['letterMentions'] != null
          ? (json['letterMentions'] as List<dynamic>).map((e) => LetterMentions.fromJson(e as Map<String, dynamic>)).toList()
          : null,
      json['receivedDepartments'] != null
          ? (json['receivedDepartments'] as List<dynamic>).map((e) => DepartmentLetters.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      json['repliesLetterCounter'] == null ? 0 : int.parse(json['repliesLetterCounter'].toString()),
      json['repliesLetter'] == null ? null : (json['repliesLetter'] as List<dynamic>).map((e) => LetterModel.fromJson(e as Map<String, dynamic>)).toList()
    );
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (filesList != null) {
      data['fileLists'] = filesList!.map((e) => e.filesToJson()).toList();
    }
    data['letterId'] = letterId;
    data['letterAbout'] = letterAbout;
    data['letterContent'] = letterContent;
    data['letterDate'] = letterDate;
    data['letterNumber'] = letterNumber;
    data['previousLetterId'] = previousLetterId;
    data['confidentialityId'] = confidentialityId;
    data['necessaryId'] = necessaryId;
    data['directionId'] = directionId;
    data['createdBy'] = createdBy;
    data['hasReply'] = hasReply;
    data['departmentId'] = departmentId;
    data['deletedBy'] = deletedBy;
    data['deletedAt'] = deletedAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

@HiveType(typeId: 3)
class FilesList {
  @HiveField(0)
  int fileListId;
  @HiveField(1)
  String filePath;
  @HiveField(2)
  String fileSize;
  @HiveField(3)
  String fileName;

  FilesList(
      this.fileListId,
      this.filePath,
      this.fileSize,
      this.fileName);

  factory FilesList.fromJson(Map<String, dynamic> json) {
    return FilesList(
        int.parse(json['fileListId'].toString()),
        AppConstants.sharePath + json['filePath'],
        json['fileSize'],
        json['fileName'],
    );
  }

  Map<String, dynamic> filesToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fileListId'] = fileListId;
    data['filePath'] = filePath;
    data['fileSize'] = fileSize;
    data['fileName'] = fileName;
    return data;
  }
}

@HiveType(typeId: 4)
class DepartmentLetters {
  @HiveField(0)
  int departmentId;
  @HiveField(1)
  int letterId;
  @HiveField(2)
  bool requiredAction;

  DepartmentLetters(
      this.departmentId,
      this.letterId,
      this.requiredAction);

  factory DepartmentLetters.fromJson(Map<String, dynamic> json) {
    return DepartmentLetters(
        int.parse(json['departmentId'].toString()),
        int.parse(json['letterId'].toString()),
        json['requiredAction'],
    );
  }

  Map<String, dynamic> filesToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['departmentId'] = departmentId;
    data['letterId'] = letterId;
    data['requiredAction'] = requiredAction;
    return data;
  }
}
@HiveType(typeId: 5)
class LetterTags {
  @HiveField(0)
  int tagId;
  @HiveField(1)
  int letterId;

  LetterTags(
      this.tagId,
      this.letterId);

  factory LetterTags.fromJson(Map<String, dynamic> json) {
    return LetterTags(
        int.parse(json['tagId'].toString()),
        json['letterId'],
    );
  }

  Map<String, dynamic> tagsToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tagId'] = tagId;
    data['letterId'] = letterId;
    return data;
  }
}
@HiveType(typeId: 6)
class LetterMentions {
  @HiveField(0)
  int letterMentionId;
  @HiveField(1)
  int letterId;
  @HiveField(2)
  String letterNumber;

  LetterMentions(
      this.letterMentionId,
      this.letterId,
      this.letterNumber);

  factory LetterMentions.fromJson(Map<String, dynamic> json) {
    return LetterMentions(
        int.parse(json['letterMentionId'].toString()),
        int.parse(json['letterId'].toString()),
        json['letterNumber'],
    );
  }

  Map<String, dynamic> mentionsToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['letterMentionId'] = letterMentionId;
    data['letterId'] = letterId;
    data['letterNumber'] = letterNumber;
    return data;
  }
}