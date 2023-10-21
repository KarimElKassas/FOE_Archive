import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';

class UpdateLetterUseCase extends BaseUseCase<String, UpdateLetterParameters> {
  BaseArchiveRepository archiveRepository;
  UpdateLetterUseCase(this.archiveRepository);

  @override
  Future<Either<Failure, String>> call(UpdateLetterParameters parameters)async {
    return await archiveRepository.updateLetter(parameters);
  }
}

class UpdateLetterParameters {
  final Map<String,dynamic> data;
  final String token;

  UpdateLetterParameters(this.data,this.token);
}