import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';

class DeleteLetterUseCase extends BaseUseCase<String, DeleteLetterParameters> {
  BaseArchiveRepository archiveRepository;
  DeleteLetterUseCase(this.archiveRepository);

  @override
  Future<Either<Failure, String>> call(DeleteLetterParameters parameters)async {
    return await archiveRepository.deleteLetter(parameters);
  }
}

class DeleteLetterParameters {
  final int letterId;
  final String token;

  DeleteLetterParameters(this.letterId,this.token);
}