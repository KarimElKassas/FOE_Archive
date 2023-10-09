abstract class LetterReplyStates{}

class LetterReplyInitial extends LetterReplyStates{}
class LetterReplyAddDepartmentToAction extends LetterReplyStates{}
class LetterReplyRemoveDepartmentFromAction extends LetterReplyStates{}
class LetterReplyChangeSecurityLevel extends LetterReplyStates{}
class LetterReplyChangeNecessaryLevel extends LetterReplyStates{}
class LetterReplyChangeSelectedDirection extends LetterReplyStates{}
class LetterReplyAddDepartmentToKnow extends LetterReplyStates{}
class LetterReplyRemoveDepartmentFromKnow extends LetterReplyStates{}
class LetterReplyAddTags extends LetterReplyStates{}
class LetterReplyChangeSelectedSector extends LetterReplyStates{}
class LetterReplyChangeColor extends LetterReplyStates{}
class LetterReplyPickFiles extends LetterReplyStates{}
class LetterReplyRemoveFile extends LetterReplyStates{}
class LetterReplyLoadingTags extends LetterReplyStates{}
class LetterReplyLoadingSectors extends LetterReplyStates{}
class LetterReplyLoadingDepartments extends LetterReplyStates{}
class LetterReplySuccessfulGetTags extends LetterReplyStates{}
class LetterReplySuccessfulGetSectors extends LetterReplyStates{}
class LetterReplySuccessfulGetDepartments extends LetterReplyStates{}
class LetterReplyErrorGetTags extends LetterReplyStates{
  final String error;

  LetterReplyErrorGetTags(this.error);
}
class LetterReplyErrorGetSectors extends LetterReplyStates{
  final String error;

  LetterReplyErrorGetSectors(this.error);
}
class LetterReplyErrorGetDepartments extends LetterReplyStates{
  final String error;

  LetterReplyErrorGetDepartments(this.error);
}
class LetterReplyLoadingSend extends LetterReplyStates{}
class LetterReplySuccessfulSend extends LetterReplyStates{}
class LetterReplyErrorSend extends LetterReplyStates{
  final String error;

  LetterReplyErrorSend(this.error);
}
class LetterReplyLoadingDirections extends LetterReplyStates{}
class LetterReplySuccessfulGetDirections extends LetterReplyStates{}
class LetterReplyErrorGetDirections extends LetterReplyStates{
  final String error;

  LetterReplyErrorGetDirections(this.error);
}
