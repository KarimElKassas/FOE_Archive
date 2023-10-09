import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';

class UploadLetterFilesUseCase extends BaseUseCase<int, UploadLetterFilesParameters> {
  BaseArchiveRepository archiveRepository;
  UploadLetterFilesUseCase(this.archiveRepository);

  @override
  Future<Either<Failure, int>> call(UploadLetterFilesParameters parameters)async {
    return await archiveRepository.uploadLetterFiles(parameters);
  }
}

class UploadLetterFilesParameters {
  final FormData data;
  final String token;

  UploadLetterFilesParameters(this.data,this.token);
}