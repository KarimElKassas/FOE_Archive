import 'package:dartz/dartz.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';
import 'get_outgoing_internal_letters_use_case.dart';

class GetOutgoingExternalLettersUseCase extends BaseUseCase<List<LetterModel>, GetOutgoingLettersParameters> {
  BaseArchiveRepository archiveRepository;
  GetOutgoingExternalLettersUseCase(this.archiveRepository);

  @override
  Future<Either<Failure, List<LetterModel>>> call(GetOutgoingLettersParameters parameters)async {
    return await archiveRepository.getOutgoingExternalLetters(parameters);
  }
}
