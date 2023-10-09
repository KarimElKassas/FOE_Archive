import 'package:dartz/dartz.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../../data/models/user_model.dart';

class GetLettersUseCase extends BaseUseCase<List<LetterModel>, GetLettersParameters> {
  BaseArchiveRepository archiveRepository;
  GetLettersUseCase(this.archiveRepository);

  @override
  Future<Either<Failure, List<LetterModel>>> call(GetLettersParameters parameters)async {
    return await archiveRepository.getLetters(parameters);
  }
}

class GetLettersParameters {
  final String data;

  GetLettersParameters(this.data);
}