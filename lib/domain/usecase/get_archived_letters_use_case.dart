import 'package:dartz/dartz.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../../data/models/user_model.dart';

class GetArchivedLettersUseCase extends BaseUseCase<List<LetterModel>, GetArchivedLettersParameters> {
  BaseArchiveRepository archiveRepository;
  GetArchivedLettersUseCase(this.archiveRepository);

  @override
  Future<Either<Failure, List<LetterModel>>> call(GetArchivedLettersParameters parameters)async {
    return await archiveRepository.getArchivedLetters(parameters);
  }
}

class GetArchivedLettersParameters {
  final String data;

  GetArchivedLettersParameters(this.data);
}