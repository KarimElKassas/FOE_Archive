import 'package:dartz/dartz.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';

class LoginUserUseCase extends BaseUseCase<String, LoginUserParameters> {
  BaseArchiveRepository archiveRepository;
  LoginUserUseCase(this.archiveRepository);

  @override
  Future<Either<Failure, String>> call(LoginUserParameters parameters)async {
    return await archiveRepository.loginUser(parameters);
  }
}

class LoginUserParameters {
  final Map<String,dynamic> data;

  LoginUserParameters(this.data);
}