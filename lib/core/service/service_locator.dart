import 'package:foe_archive/data/datasource/local/letter_local_data_source.dart';
import 'package:foe_archive/data/datasource/remote/remote_data_source.dart';
import 'package:foe_archive/data/repository/archive_repository.dart';
import 'package:foe_archive/domain/repository/base_archive_repository.dart';
import 'package:foe_archive/domain/usecase/create_archived_letter_use_case.dart';
import 'package:foe_archive/domain/usecase/create_for_me_letter_use_case.dart';
import 'package:foe_archive/domain/usecase/create_letter_use_case.dart';
import 'package:foe_archive/domain/usecase/delete_letter_use_case.dart';
import 'package:foe_archive/domain/usecase/get_all_departments_use_case.dart';
import 'package:foe_archive/domain/usecase/get_archived_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_departments_use_case.dart';
import 'package:foe_archive/domain/usecase/get_directions_use_case.dart';
import 'package:foe_archive/domain/usecase/get_for_me_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_incoming_external_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_incoming_internal_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_letter_by_id_use_case.dart';
import 'package:foe_archive/domain/usecase/get_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_outgoing_external_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_outgoing_internal_letters_use_case.dart';
import 'package:foe_archive/domain/usecase/get_sectors_use_case.dart';
import 'package:foe_archive/domain/usecase/get_tags_use_case.dart';
import 'package:foe_archive/domain/usecase/get_user_use_case.dart';
import 'package:foe_archive/domain/usecase/update_letter_use_case.dart';
import 'package:foe_archive/domain/usecase/upload_letter_files_use_case.dart';
import 'package:foe_archive/presentation/archived_letter/bloc/archived_letter_cubit.dart';
import 'package:foe_archive/presentation/home/bloc/home_cubit.dart';
import 'package:foe_archive/presentation/incoming_letters/bloc/incoming_letters_cubit.dart';
import 'package:foe_archive/presentation/letter_details/bloc/letter_details_cubit.dart';
import 'package:foe_archive/presentation/letter_reply/bloc/letter_reply_cubit.dart';
import 'package:foe_archive/presentation/new_letter/bloc/new_letter_cubit.dart';
import 'package:foe_archive/presentation/outgoing_letters/bloc/outgoing_letters_cubit.dart';
import 'package:foe_archive/presentation/secretary/incoming_external_letters/bloc/incoming_external_letters_cubit.dart';
import 'package:foe_archive/presentation/secretary/incoming_internal_letters/bloc/incoming_internal_letters_cubit.dart';
import 'package:foe_archive/presentation/secretary/outgoing_external_letters/bloc/outgoing_external_letters_cubit.dart';
import 'package:foe_archive/presentation/update_letter/bloc/update_letter_cubit.dart';
import 'package:get_it/get_it.dart';

import '../../domain/usecase/login_user_use_case.dart';
import '../../presentation/login/bloc/login_cubit.dart';
import '../../presentation/secretary/home/bloc/secretary_home_cubit.dart';
import '../../presentation/secretary/outgoing_internal_letters/bloc/outgoing_internal_letters_cubit.dart';

final sl = GetIt.instance;

class ServiceLocator {
  void setup() {
    /// Blocs
    sl.registerFactory(() => LoginCubit(sl(), sl()));
    sl.registerFactory(() => HomeCubit(sl(),sl()));
    sl.registerFactory(() => SecretaryHomeCubit(sl(),sl()));
    sl.registerFactory(() => LetterDetailsCubit(sl(),sl(),sl(),sl()));
    sl.registerFactory(() => LetterReplyCubit(sl(),sl(),sl(),sl(),sl(),sl()));
    sl.registerFactory(() => NewLetterCubit(sl(),sl(),sl(),sl(),sl(),sl(),sl()));
    sl.registerFactory(() => ArchivedLettersCubit(sl(),sl(),sl(),sl(),sl(),sl(),sl(),sl(),sl(),sl()));
    sl.registerFactory(() => IncomingLettersCubit(sl(),sl()));
    sl.registerFactory(() => OutgoingLettersCubit(sl(),sl()));
    sl.registerFactory(() => IncomingInternalLettersCubit(sl()));
    sl.registerFactory(() => IncomingExternalLettersCubit(sl()));
    sl.registerFactory(() => OutgoingInternalLettersCubit(sl()));
    sl.registerFactory(() => OutgoingExternalLettersCubit(sl()));
    sl.registerFactory(() => UpdateLetterCubit(sl(),sl(),sl(),sl(),sl()));

    /// Remote Data Source
    sl.registerLazySingleton<BaseArchiveRemoteDataSource>(() => ArchiveRemoteDataSource());
    /// Local Data Source
    sl.registerLazySingleton<BaseLetterLocalDataSource>(() => LetterLocalDataSource());

    /// Base Archive Repository
    sl.registerLazySingleton<BaseArchiveRepository>(() => ArchiveRepository(sl(),sl()));

    ///Use Cases
    sl.registerLazySingleton<LoginUserUseCase>(() => LoginUserUseCase(sl()));
    sl.registerLazySingleton<GetUserUseCase>(() => GetUserUseCase(sl()));
    sl.registerLazySingleton<GetLettersUseCase>(() => GetLettersUseCase(sl()));
    sl.registerLazySingleton<GetArchivedLettersUseCase>(() => GetArchivedLettersUseCase(sl()));
    sl.registerLazySingleton<GetForMeLettersUseCase>(() => GetForMeLettersUseCase(sl()));
    sl.registerLazySingleton<GetDirectionsUseCase>(() => GetDirectionsUseCase(sl()));
    sl.registerLazySingleton<CreateLetterUseCase>(() => CreateLetterUseCase(sl()));
    sl.registerLazySingleton<CreateArchivedLetterUseCase>(() => CreateArchivedLetterUseCase(sl()));
    sl.registerLazySingleton<CreateForMeLetterUseCase>(() => CreateForMeLetterUseCase(sl()));
    sl.registerLazySingleton<UploadLetterFilesUseCase>(() => UploadLetterFilesUseCase(sl()));
    sl.registerLazySingleton<GetTagsUseCase>(() => GetTagsUseCase(sl()));
    sl.registerLazySingleton<GetSectorsUseCase>(() => GetSectorsUseCase(sl()));
    sl.registerLazySingleton<GetDepartmentsUseCase>(() => GetDepartmentsUseCase(sl()));
    sl.registerLazySingleton<GetAllDepartmentsUseCase>(() => GetAllDepartmentsUseCase(sl()));
    sl.registerLazySingleton<GetIncomingInternalLettersUseCase>(() => GetIncomingInternalLettersUseCase(sl()));
    sl.registerLazySingleton<GetIncomingExternalLettersUseCase>(() => GetIncomingExternalLettersUseCase(sl()));
    sl.registerLazySingleton<GetOutgoingInternalLettersUseCase>(() => GetOutgoingInternalLettersUseCase(sl()));
    sl.registerLazySingleton<GetOutgoingExternalLettersUseCase>(() => GetOutgoingExternalLettersUseCase(sl()));
    sl.registerLazySingleton<GetLetterByIdUseCase>(() => GetLetterByIdUseCase(sl()));
    sl.registerLazySingleton<UpdateLetterUseCase>(() => UpdateLetterUseCase(sl()));
    sl.registerLazySingleton<DeleteLetterUseCase>(() => DeleteLetterUseCase(sl()));

  }
}