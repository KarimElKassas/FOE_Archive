abstract class NewLetterStates{}
class NewLetterInitial extends NewLetterStates{}
class NewLetterLoadingGetLetter extends NewLetterStates{}
class NewLetterLoadingCreate extends NewLetterStates{}
class NewLetterSuccessfulCreate extends NewLetterStates{}
class NewLetterSuccessfulGetLetter extends NewLetterStates{}
class NewLetterErrorCreate extends NewLetterStates{
  final String error;

  NewLetterErrorCreate(this.error);
}
class NewLetterErrorGetLetter extends NewLetterStates{
  final String error;

  NewLetterErrorGetLetter(this.error);
}
class NewLetterAddDepartmentToAction extends NewLetterStates{}
class NewLetterChangeSecurityLevel extends NewLetterStates{}
class NewLetterChangeNecessaryLevel extends NewLetterStates{}
class NewLetterRemoveDepartmentFromAction extends NewLetterStates{}
class NewLetterAddDepartmentToKnow extends NewLetterStates{}
class NewLetterRemoveDepartmentFromKnow extends NewLetterStates{}
class NewLetterAddTags extends NewLetterStates{}
class NewLetterChangeSelectedSector extends NewLetterStates{}
class NewLetterChangeSelectedDirection extends NewLetterStates{}
class NewLetterChangeColor extends NewLetterStates{}
class NewLetterPickFiles extends NewLetterStates{}
class NewLetterRemoveFile extends NewLetterStates{}
class NewLetterLoadingTags extends NewLetterStates{}
class NewLetterLoadingSectors extends NewLetterStates{}
class NewLetterLoadingDepartments extends NewLetterStates{}
class NewLetterLoadingDirections extends NewLetterStates{}
class NewLetterSuccessfulGetTags extends NewLetterStates{}
class NewLetterSuccessfulGetSectors extends NewLetterStates{}
class NewLetterSuccessfulGetDepartments extends NewLetterStates{}
class NewLetterSuccessfulGetDirections extends NewLetterStates{}
class NewLetterErrorGetTags extends NewLetterStates{
  final String error;

  NewLetterErrorGetTags(this.error);
}
class NewLetterErrorGetSectors extends NewLetterStates{
  final String error;

  NewLetterErrorGetSectors(this.error);
}
class NewLetterErrorGetDepartments extends NewLetterStates{
  final String error;

  NewLetterErrorGetDepartments(this.error);
}
class NewLetterErrorGetDirections extends NewLetterStates{
  final String error;

  NewLetterErrorGetDirections(this.error);
}