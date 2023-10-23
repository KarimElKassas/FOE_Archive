import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:foe_archive/core/use_case/base_use_case.dart';
import 'package:foe_archive/data/datasource/local/letter_local_data_source.dart';
import 'package:foe_archive/data/datasource/remote/remote_data_source.dart';
import 'package:foe_archive/data/models/department_model.dart';
import 'package:foe_archive/data/models/direction_model.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/data/models/sector_model.dart';
import 'package:foe_archive/data/models/tag_model.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';
import 'package:foe_archive/domain/usecase/create_letter_use_case.dart';
import 'package:foe_archive/domain/usecase/delete_letter_use_case.dart';
import 'package:foe_archive/domain/usecase/get_all_departments_use_case.dart';
import 'package:foe_archive/domain/usecase/get_archived_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_departments_use_case.dart';
import 'package:foe_archive/domain/usecase/get_directions_use_case.dart';
import 'package:foe_archive/domain/usecase/get_for_me_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_incoming_internal_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_letter_by_id_use_case.dart';
import 'package:foe_archive/domain/usecase/get_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_outgoing_internal_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_sectors_use_case.dart';
import 'package:foe_archive/domain/usecase/get_tags_use_case.dart';
import 'package:foe_archive/domain/usecase/update_letter_use_case.dart';
import 'package:foe_archive/domain/usecase/upload_letter_files_use_case.dart';

import '../../core/error/failure.dart';
import '../../domain/usecase/get_user_use_case.dart';
import '../../domain/usecase/login_user_use_case.dart';
import '../models/user_model.dart';

class ArchiveRepository extends BaseArchiveRepository{
  BaseArchiveRemoteDataSource remoteDataSource;
  BaseLetterLocalDataSource localDataSource;
  ArchiveRepository(this.remoteDataSource,this.localDataSource);
  @override
  Future<Either<Failure, String>> loginUser(LoginUserParameters parameters)async {
    try{
      final result = await remoteDataSource.loginUser(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUser(GetUserParameters parameters)async {
    try{
      final result = await remoteDataSource.getUser(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, List<LetterModel>>> getLetters(GetLettersParameters parameters)async {
    try{
      final result = await remoteDataSource.getLetters(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      print(e);
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, List<DirectionModel>>> getDirections(GetDirectionsParameters parameters)async {
    try{
      final result = await remoteDataSource.getDirections(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, int>> createLetter(CreateLetterParameters parameters)async {
    try{
      final result = await remoteDataSource.createLetter(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        print("ERROR DIO : $e");
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, int>> uploadLetterFiles(UploadLetterFilesParameters parameters)async {
    try{
      final result = await remoteDataSource.uploadLetterFiles(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        print("ERROR DIO : $e");
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, List<TagModel>>> getTags(GetTagsParameters parameters)async {
    try{
      final result = await remoteDataSource.getTags(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, List<DepartmentModel>>> getDepartments(GetDepartmentsParameters parameters)async {
    try{
      final result = await remoteDataSource.getDepartments(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, List<SectorModel>>> getSectors(GetSectorsParameters parameters)async {
    try{
      final result = await remoteDataSource.getSectors(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, List<DepartmentModel>>> getAllDepartments(GetAllDepartmentsParameters parameters)async {
    try{
      final result = await remoteDataSource.getAllDepartments(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, List<LetterModel>>> getIncomingInternalLetters(GetIncomingLettersParameters parameters)async {
    final result = await remoteDataSource.getIncomingInternalLetters(parameters);
    try{
      //await localDataSource.addIncomingInternalLettersToCache(result);
      return Right(result);
    } catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      print(e);
      return left(e as ServerFailure);
    }
    try{
      final letters = await localDataSource.getIncomingInternalLetters(const NoParameters());
      return Right(letters);
    } on EmptyCacheFailure{
      final result = await remoteDataSource.getIncomingInternalLetters(parameters);
      try{
        await localDataSource.addIncomingInternalLettersToCache(result);
        return Right(result);
      } catch (e){
        if (e is DioException){
          return left(ServerFailure.fromDioError(e));
        }
        print(e);
        return left(e as ServerFailure);
      }
    }
  }

  @override
  Future<Either<Failure, int>> createArchivedLetter(CreateLetterParameters parameters)async {
    try{
      final result = await remoteDataSource.createArchivedLetter(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        print("ERROR DIO : $e");
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, int>> createForMeLetter(CreateLetterParameters parameters)async {
    try{
      final result = await remoteDataSource.createForMeLetter(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        print("ERROR DIO : $e");
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, List<LetterModel>>> getArchivedLetters(GetArchivedLettersParameters parameters)async {
    final result = await remoteDataSource.getArchivedLetters(parameters);
    try{
     // await localDataSource.addArchivedLettersToCache(result);
      return Right(result);
    } catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      print(e);
      return left(e as ServerFailure);
    }
    try{
      final letters = await localDataSource.getArchivedLetters(const NoParameters());
      print("RETURN Archived List From Cache ## : $letters");
      return Right(letters);
    } on EmptyCacheFailure{
      final result = await remoteDataSource.getArchivedLetters(parameters);
      try{
        await localDataSource.addArchivedLettersToCache(result);
        return Right(result);
      } catch (e){
        if (e is DioException){
          return left(ServerFailure.fromDioError(e));
        }
        print(e);
        return left(e as ServerFailure);
      }
    }
  }

  @override
  Future<Either<Failure, List<LetterModel>>> getForMeLetters(GetForMeLettersParameters parameters)async {
    final result = await remoteDataSource.getForMeLetters(parameters);
    try{
      //await localDataSource.addForMeLettersToCache(result);
      return Right(result);
    } catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      print(e);
      return left(e as ServerFailure);
    }
    try{
      final letters = await localDataSource.getForMeLetters(const NoParameters());
      return Right(letters);
    } on EmptyCacheFailure{
      final result = await remoteDataSource.getForMeLetters(parameters);
      try{
        await localDataSource.addForMeLettersToCache(result);
        return Right(result);
      } catch (e){
        if (e is DioException){
          return left(ServerFailure.fromDioError(e));
        }
        print(e);
        return left(e as ServerFailure);
      }
    }
  }

  @override
  Future<Either<Failure, LetterModel?>> getLetterId(GetLetterByIdParameters parameters)async {
    try{
      final result = await remoteDataSource.getLetterById(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        print("ERROR DIO : $e");
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, List<LetterModel>>> getOutgoingExternalLetters(GetOutgoingLettersParameters parameters)async {
    final result = await remoteDataSource.getOutgoingExternalLetters(parameters);
    try{
      //await localDataSource.addOutgoingExternalLettersToCache(result);
      return Right(result);
    } catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      print(e);
      return left(e as ServerFailure);
    }
    try{
      final letters = await localDataSource.getOutgoingExternalLetters(const NoParameters());
      return Right(letters);
    } on EmptyCacheFailure{
      final result = await remoteDataSource.getOutgoingExternalLetters(parameters);
      try{
        await localDataSource.addOutgoingExternalLettersToCache(result);
        return Right(result);
      } catch (e){
        if (e is DioException){
          return left(ServerFailure.fromDioError(e));
        }
        print(e);
        return left(e as ServerFailure);
      }
    }

  }

  @override
  Future<Either<Failure, List<LetterModel>>> getOutgoingInternalLetters(GetOutgoingLettersParameters parameters)async {
    final result = await remoteDataSource.getOutgoingInternalLetters(parameters);
    try{
      //await localDataSource.addOutgoingInternalLettersToCache(result);
      return Right(result);
    } catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      print(e);
      return left(e as ServerFailure);
    }
    try{
      final letters = await localDataSource.getOutgoingInternalLetters(const NoParameters());
      return Right(letters);
    } on EmptyCacheFailure{
      final result = await remoteDataSource.getOutgoingInternalLetters(parameters);
      try{
        await localDataSource.addOutgoingInternalLettersToCache(result);
        return Right(result);
      } catch (e){
        if (e is DioException){
          return left(ServerFailure.fromDioError(e));
        }
        print(e);
        return left(e as ServerFailure);
      }
    }
  }

  @override
  Future<Either<Failure, List<LetterModel>>> getIncomingExternalLetters(GetIncomingLettersParameters parameters)async {
    final result = await remoteDataSource.getIncomingExternalLetters(parameters);
    try{
      //await localDataSource.addIncomingExternalLettersToCache(result);
      return Right(result);
    } catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      print(e);
      return left(e as ServerFailure);
    }
    try{
      final letters = await localDataSource.getIncomingExternalLetters(const NoParameters());
      return Right(letters);
    } on EmptyCacheFailure{
      final result = await remoteDataSource.getIncomingExternalLetters(parameters);
      try{
        await localDataSource.addIncomingExternalLettersToCache(result);
        return Right(result);
      } catch (e){
        if (e is DioException){
          return left(ServerFailure.fromDioError(e));
        }
        print(e);
        return left(e as ServerFailure);
      }
    }
  }

  @override
  Future<Either<Failure, String>> updateLetter(UpdateLetterParameters parameters)async {
    try{
      final result = await remoteDataSource.updateLetter(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      print(e);
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, String>> deleteLetter(DeleteLetterParameters parameters)async {
    try{
      final result = await remoteDataSource.deleteLetter(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      print(e);
      return left(e as ServerFailure);
    }
  }
}