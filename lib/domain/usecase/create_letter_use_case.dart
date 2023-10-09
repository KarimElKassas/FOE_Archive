import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';

class CreateLetterUseCase extends BaseUseCase<int, CreateLetterParameters> {
  BaseArchiveRepository archiveRepository;
  CreateLetterUseCase(this.archiveRepository);

  @override
  Future<Either<Failure, int>> call(CreateLetterParameters parameters)async {
    return await archiveRepository.createLetter(parameters);
  }
}

class CreateLetterParameters {
  final Map<String,dynamic> data;
  final String token;

  CreateLetterParameters(this.data,this.token);
}