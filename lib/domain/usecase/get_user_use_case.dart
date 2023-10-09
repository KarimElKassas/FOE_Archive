import 'package:dartz/dartz.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../../data/models/user_model.dart';

class GetUserUseCase extends BaseUseCase<UserModel, GetUserParameters> {
  BaseArchiveRepository archiveRepository;
  GetUserUseCase(this.archiveRepository);

  @override
  Future<Either<Failure, UserModel>> call(GetUserParameters parameters)async {
    return await archiveRepository.getUser(parameters);
  }
}

class GetUserParameters {
  final String data;
  final String password;

  GetUserParameters(this.data,this.password);
}