import 'package:dartz/dartz.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../../data/models/user_model.dart';

class GetOutgoingInternalLettersUseCase extends BaseUseCase<List<LetterModel>, GetOutgoingLettersParameters> {
  BaseArchiveRepository archiveRepository;
  GetOutgoingInternalLettersUseCase(this.archiveRepository);

  @override
  Future<Either<Failure, List<LetterModel>>> call(GetOutgoingLettersParameters parameters)async {
    return await archiveRepository.getOutgoingInternalLetters(parameters);
  }
}

class GetOutgoingLettersParameters {
  final String data;

  GetOutgoingLettersParameters(this.data);
}