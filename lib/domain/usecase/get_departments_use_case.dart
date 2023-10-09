import 'package:dartz/dartz.dart';
import 'package:foe_archive/data/models/department_model.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';

class GetDepartmentsUseCase extends BaseUseCase<List<DepartmentModel>, GetDepartmentsParameters> {
  BaseArchiveRepository archiveRepository;
  GetDepartmentsUseCase(this.archiveRepository);

  @override
  Future<Either<Failure, List<DepartmentModel>>> call(GetDepartmentsParameters parameters)async {
    return await archiveRepository.getDepartments(parameters);
  }
}

class GetDepartmentsParameters {
  final int sectorId;
  final String token;

  GetDepartmentsParameters(this.token,this.sectorId);
}