import 'package:dartz/dartz.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/data/models/sector_model.dart';
import 'package:foe_archive/data/models/tag_model.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../../data/models/user_model.dart';

class GetSectorsUseCase extends BaseUseCase<List<SectorModel>, GetSectorsParameters> {
  BaseArchiveRepository archiveRepository;
  GetSectorsUseCase(this.archiveRepository);

  @override
  Future<Either<Failure, List<SectorModel>>> call(GetSectorsParameters parameters)async {
    return await archiveRepository.getSectors(parameters);
  }
}

class GetSectorsParameters {
  final String data;

  GetSectorsParameters(this.data);
}