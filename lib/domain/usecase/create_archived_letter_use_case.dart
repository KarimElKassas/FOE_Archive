import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';
import 'package:foe_archive/domain/usecase/create_letter_use_case.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';

class CreateArchivedLetterUseCase extends BaseUseCase<int, CreateLetterParameters> {
  BaseArchiveRepository archiveRepository;
  CreateArchivedLetterUseCase(this.archiveRepository);

  @override
  Future<Either<Failure, int>> call(CreateLetterParameters parameters)async {
    return await archiveRepository.createArchivedLetter(parameters);
  }
}
