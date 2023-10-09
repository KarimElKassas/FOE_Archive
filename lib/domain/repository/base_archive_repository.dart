import 'package:dartz/dartz.dart';
import 'package:foe_archive/data/models/department_model.dart';
import 'package:foe_archive/data/models/direction_model.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/data/models/sector_model.dart';
import 'package:foe_archive/data/models/tag_model.dart';
import 'package:foe_archive/domain/usecase/create_letter_use_case.dart';
import 'package:foe_archive/domain/usecase/get_all_departments_use_case.dart';
import 'package:foe_archive/domain/usecase/get_archived_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_departments_use_case.dart';
import 'package:foe_archive/domain/usecase/get_directions_use_case.dart';
import 'package:foe_archive/domain/usecase/get_for_me_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_incoming_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_letter_by_id_use_case.dart';
import 'package:foe_archive/domain/usecase/get_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_outgoing_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_sectors_use_case.dart';
import 'package:foe_archive/domain/usecase/get_tags_use_case.dart';
import 'package:foe_archive/domain/usecase/upload_letter_files_use_case.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/user_model.dart';
import '../usecase/get_user_use_case.dart';
import '../usecase/login_user_use_case.dart';

abstract class BaseArchiveRepository {
  Future<Either<Failure, String>> loginUser(LoginUserParameters parameters);
  Future<Either<Failure, UserModel>> getUser(GetUserParameters parameters);
  Future<Either<Failure, List<LetterModel>>> getLetters(GetLettersParameters parameters);
  Future<Either<Failure, LetterModel?>> getLetterId(GetLetterByIdParameters parameters);
  Future<Either<Failure, List<LetterModel>>> getIncomingLetters(GetIncomingLettersParameters parameters);
  Future<Either<Failure, List<LetterModel>>> getOutgoingLetters(GetOutgoingLettersParameters parameters);
  Future<Either<Failure, List<LetterModel>>> getArchivedLetters(GetArchivedLettersParameters parameters);
  Future<Either<Failure, List<LetterModel>>> getForMeLetters(GetForMeLettersParameters parameters);
  Future<Either<Failure, int>> createLetter(CreateLetterParameters parameters);
  Future<Either<Failure, int>> createArchivedLetter(CreateLetterParameters parameters);
  Future<Either<Failure, int>> createForMeLetter(CreateLetterParameters parameters);
  Future<Either<Failure, int>> uploadLetterFiles(UploadLetterFilesParameters parameters);
  Future<Either<Failure, List<DirectionModel>>> getDirections(GetDirectionsParameters parameters);
  Future<Either<Failure, List<TagModel>>> getTags(GetTagsParameters parameters);
  Future<Either<Failure, List<SectorModel>>> getSectors(GetSectorsParameters parameters);
  Future<Either<Failure, List<DepartmentModel>>> getDepartments(GetDepartmentsParameters parameters);
  Future<Either<Failure, List<DepartmentModel>>> getAllDepartments(GetAllDepartmentsParameters parameters);

}