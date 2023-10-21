abstract class UpdateLetterStates{}

class UpdateLetterInitState extends UpdateLetterStates{}
class UpdateLetterPickFiles extends UpdateLetterStates{}
class UpdateLetterRemoveFile extends UpdateLetterStates{}
class UpdateLetterRemoveDepartmentFromAction extends UpdateLetterStates{}
class UpdateLetterRemoveDepartmentFromKnow extends UpdateLetterStates{}
class UpdateLetterAddDepartmentToAction extends UpdateLetterStates{}
class UpdateLetterAddDepartmentToKnow extends UpdateLetterStates{}
class UpdateLetterAddTags extends UpdateLetterStates{}
class UpdateLetterChangeSelectedSector extends UpdateLetterStates{}
class UpdateLetterChangeSelectedDirection extends UpdateLetterStates{}
class UpdateLetterChangeSecurityLevel extends UpdateLetterStates{}
class UpdateLetterChangeNecessaryLevel extends UpdateLetterStates{}
class UpdateLetterLoadingDirections extends UpdateLetterStates{}
class UpdateLetterLoadingSectors extends UpdateLetterStates{}
class UpdateLetterLoadingDepartments extends UpdateLetterStates{}
class UpdateLetterLoadingTags extends UpdateLetterStates{}
class UpdateLetterLoading extends UpdateLetterStates{}
class UpdateLetterSuccessful extends UpdateLetterStates{}
class UpdateLetterSuccessfulGetDirections extends UpdateLetterStates{}
class UpdateLetterSuccessfulGetTags extends UpdateLetterStates{}
class UpdateLetterSuccessfulGetSectors extends UpdateLetterStates{}
class UpdateLetterSuccessfulGetDepartments extends UpdateLetterStates{}
class UpdateLetterError extends UpdateLetterStates{
  final String error;

  UpdateLetterError(this.error);
}
class UpdateLetterErrorGetDepartments extends UpdateLetterStates{
  final String error;

  UpdateLetterErrorGetDepartments(this.error);
}
class UpdateLetterErrorGetSectors extends UpdateLetterStates{
  final String error;

  UpdateLetterErrorGetSectors(this.error);
}
class UpdateLetterErrorGetDirections extends UpdateLetterStates{
  final String error;

  UpdateLetterErrorGetDirections(this.error);
}
class UpdateLetterErrorGetTags extends UpdateLetterStates{
  final String error;

  UpdateLetterErrorGetTags(this.error);
}