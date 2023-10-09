import 'package:dartz/dartz.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../../data/models/user_model.dart';

class GetLetterByIdUseCase extends BaseUseCase<LetterModel?, GetLetterByIdParameters> {
  BaseArchiveRepository archiveRepository;
  GetLetterByIdUseCase(this.archiveRepository);

  @override
  Future<Either<Failure, LetterModel?>> call(GetLetterByIdParameters parameters)async {
    return await archiveRepository.getLetterId(parameters);
  }
}

class GetLetterByIdParameters {
  final int letterId;
  final String token;
  GetLetterByIdParameters(this.letterId,this.token);
}