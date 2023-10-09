import 'package:dartz/dartz.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../../data/models/user_model.dart';

class GetIncomingLettersUseCase extends BaseUseCase<List<LetterModel>, GetIncomingLettersParameters> {
  BaseArchiveRepository archiveRepository;
  GetIncomingLettersUseCase(this.archiveRepository);

  @override
  Future<Either<Failure, List<LetterModel>>> call(GetIncomingLettersParameters parameters)async {
    return await archiveRepository.getIncomingLetters(parameters);
  }
}

class GetIncomingLettersParameters {
  final String data;

  GetIncomingLettersParameters(this.data);
}