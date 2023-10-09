import 'package:dartz/dartz.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../../data/models/user_model.dart';

class GetForMeLettersUseCase extends BaseUseCase<List<LetterModel>, GetForMeLettersParameters> {
  BaseArchiveRepository archiveRepository;
  GetForMeLettersUseCase(this.archiveRepository);

  @override
  Future<Either<Failure, List<LetterModel>>> call(GetForMeLettersParameters parameters)async {
    return await archiveRepository.getForMeLetters(parameters);
  }
}

class GetForMeLettersParameters {
  final String data;

  GetForMeLettersParameters(this.data);
}