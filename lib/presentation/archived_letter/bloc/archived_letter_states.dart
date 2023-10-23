abstract class ArchivedLettersStates{}

class ArchivedLettersInitial extends ArchivedLettersStates{}
class ArchivedLettersInitController extends ArchivedLettersStates{}
class ArchivedLettersChangeLetterType extends ArchivedLettersStates{}
class ArchivedLettersChangeDate extends ArchivedLettersStates{}
class ArchivedLettersChangeSecurityLevel extends ArchivedLettersStates{}
class ArchivedLettersChangeNecessaryLevel extends ArchivedLettersStates{}
class ArchivedLettersChangeShowSuggestions extends ArchivedLettersStates{}
class ArchivedLettersUpdateSuggestions extends ArchivedLettersStates{}
class ArchivedLettersUpdateContent extends ArchivedLettersStates{}
class ArchivedLettersChangeOldArchived extends ArchivedLettersStates{}
class ArchivedLettersPickFiles extends ArchivedLettersStates{}
class ArchivedLettersRemoveFile extends ArchivedLettersStates{}
class ArchivedLettersChangeSelectedDirection extends ArchivedLettersStates{}
class ArchivedLettersRemoveDepartmentFromAction extends ArchivedLettersStates{}
class ArchivedLettersRemoveDepartmentFromKnow extends ArchivedLettersStates{}
class ArchivedLettersAddDepartmentToAction extends ArchivedLettersStates{}
class ArchivedLettersAddDepartmentToKnow extends ArchivedLettersStates{}
class ArchivedLettersAddTags extends ArchivedLettersStates{}
class ArchivedLettersSearchLetters extends ArchivedLettersStates{}
class ArchivedLettersChangeSelectedSector extends ArchivedLettersStates{}
class ArchivedLettersLoadingGetLetter extends ArchivedLettersStates{}
class ArchiveLettersLoadingDirections extends ArchivedLettersStates{}
class ArchivedLettersLoadingDepartments extends ArchivedLettersStates{}
class ArchivedLettersSuccessfulGetDirections extends ArchivedLettersStates{}
class ArchivedLettersSuccessfulGetLetter extends ArchivedLettersStates{}
class ArchivedLettersSuccessfulGetDepartments extends ArchivedLettersStates{}
class ArchivedLettersErrorGetDepartments extends ArchivedLettersStates{
  final String error;

  ArchivedLettersErrorGetDepartments(this.error);
}
class ArchivedLettersErrorGetDirections extends ArchivedLettersStates{
  final String error;

  ArchivedLettersErrorGetDirections(this.error);
}
class ArchivedLettersErrorGetLetter extends ArchivedLettersStates{
  final String error;

  ArchivedLettersErrorGetLetter(this.error);
}
class ArchivedLettersLoadingTags extends ArchivedLettersStates{}
class ArchivedLettersSuccessfulGetTags extends ArchivedLettersStates{}
class ArchivedLettersErrorGetTags extends ArchivedLettersStates{
  final String error;

  ArchivedLettersErrorGetTags(this.error);
}
class ArchivedLettersLoadingSectors extends ArchivedLettersStates{}
class ArchivedLettersSuccessfulGetSectors extends ArchivedLettersStates{}
class ArchivedLettersErrorGetSectors extends ArchivedLettersStates{
  final String error;

  ArchivedLettersErrorGetSectors(this.error);
}
class ArchivedLettersLoadingCreateLetter extends ArchivedLettersStates{}
class ArchivedLettersSuccessCreateLetter extends ArchivedLettersStates{}
class ArchivedLettersErrorCreateLetter extends ArchivedLettersStates{
  final String error;

  ArchivedLettersErrorCreateLetter(this.error);
}
class ArchivedLettersLoadingLetters extends ArchivedLettersStates{}
class ArchivedLettersSuccessfulGetLetters extends ArchivedLettersStates{}
class ArchivedLettersErrorGetLetters extends ArchivedLettersStates{
  final String error;

  ArchivedLettersErrorGetLetters(this.error);
}
