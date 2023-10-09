import 'package:dartz/dartz.dart';
import 'package:foe_archive/data/models/department_model.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';

class GetAllDepartmentsUseCase extends BaseUseCase<List<DepartmentModel>, GetAllDepartmentsParameters> {
  BaseArchiveRepository archiveRepository;
  GetAllDepartmentsUseCase(this.archiveRepository);

  @override
  Future<Either<Failure, List<DepartmentModel>>> call(GetAllDepartmentsParameters parameters)async {
    return await archiveRepository.getAllDepartments(parameters);
  }
}

class GetAllDepartmentsParameters {
  final String token;

  GetAllDepartmentsParameters(this.token);
}