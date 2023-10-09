import 'package:dartz/dartz.dart';
import 'package:foe_archive/data/models/direction_model.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../../data/models/user_model.dart';

class GetDirectionsUseCase extends BaseUseCase<List<DirectionModel>, GetDirectionsParameters> {
  BaseArchiveRepository archiveRepository;
  GetDirectionsUseCase(this.archiveRepository);

  @override
  Future<Either<Failure, List<DirectionModel>>> call(GetDirectionsParameters parameters)async {
    return await archiveRepository.getDirections(parameters);
  }
}

class GetDirectionsParameters {
  final String data;

  GetDirectionsParameters(this.data);
}