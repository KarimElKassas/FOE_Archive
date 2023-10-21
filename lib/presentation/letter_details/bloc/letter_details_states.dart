abstract class LetterDetailsStates{}

class LetterDetailsInitial extends LetterDetailsStates{}
class LetterDetailsChangeColor extends LetterDetailsStates{}
class LetterDetailsLoadingSectors extends LetterDetailsStates{}
class LetterDetailsLoadingDeleteLetter extends LetterDetailsStates{}
class LetterDetailsLoadingLetter extends LetterDetailsStates{}
class LetterDetailsLoadingDepartments extends LetterDetailsStates{}
class LetterDetailsSuccessfulDeleteLetter extends LetterDetailsStates{}
class LetterDetailsSuccessfulGetTags extends LetterDetailsStates{}
class LetterDetailsSuccessfulGetSectors extends LetterDetailsStates{}
class LetterDetailsSuccessfulGetLetter extends LetterDetailsStates{}
class LetterDetailsSuccessfulGetDepartments extends LetterDetailsStates{}
class LetterDetailsErrorDeleteLetter extends LetterDetailsStates{
  final String error;

  LetterDetailsErrorDeleteLetter(this.error);
}
class LetterDetailsErrorGetTags extends LetterDetailsStates{
  final String error;

  LetterDetailsErrorGetTags(this.error);
}
class LetterDetailsErrorGetSectors extends LetterDetailsStates{
  final String error;

  LetterDetailsErrorGetSectors(this.error);
}
class LetterDetailsErrorGetLetter extends LetterDetailsStates{
  final String error;

  LetterDetailsErrorGetLetter(this.error);
}
class LetterDetailsErrorGetDepartments extends LetterDetailsStates{
  final String error;

  LetterDetailsErrorGetDepartments(this.error);
}