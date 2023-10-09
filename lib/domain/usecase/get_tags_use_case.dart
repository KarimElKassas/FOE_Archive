import 'package:dartz/dartz.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/data/models/tag_model.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../../data/models/user_model.dart';

class GetTagsUseCase extends BaseUseCase<List<TagModel>, GetTagsParameters> {
  BaseArchiveRepository archiveRepository;
  GetTagsUseCase(this.archiveRepository);

  @override
  Future<Either<Failure, List<TagModel>>> call(GetTagsParameters parameters)async {
    return await archiveRepository.getTags(parameters);
  }
}

class GetTagsParameters {
  final String data;

  GetTagsParameters(this.data);
}