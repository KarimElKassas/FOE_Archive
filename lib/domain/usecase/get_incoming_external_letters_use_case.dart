import 'package:dartz/dartz.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';
import 'package:foe_archive/domain/usecase/get_incoming_internal_letters_use_case.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../../data/models/user_model.dart';

class GetIncomingExternalLettersUseCase extends BaseUseCase<List<LetterModel>, GetIncomingLettersParameters> {
  BaseArchiveRepository archiveRepository;
  GetIncomingExternalLettersUseCase(this.archiveRepository);

  @override
  Future<Either<Failure, List<LetterModel>>> call(GetIncomingLettersParameters parameters)async {
    return await archiveRepository.getIncomingExternalLetters(parameters);
  }
}
