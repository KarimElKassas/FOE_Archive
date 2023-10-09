abstract class IncomingInternalLettersStates{}

class IncomingInternalLettersInitial extends IncomingInternalLettersStates{}
class IncomingInternalLettersChangeSelectedLetter extends IncomingInternalLettersStates{}
class IncomingInternalLettersChangeSortMethod extends IncomingInternalLettersStates{}
class IncomingInternalLettersSearchLetters extends IncomingInternalLettersStates{}
class IncomingInternalLettersLoadingLetters extends IncomingInternalLettersStates{}
class IncomingInternalLettersSuccessfulGetLetters extends IncomingInternalLettersStates{}
class IncomingInternalLettersErrorGetLetters extends IncomingInternalLettersStates{
  final String error;

  IncomingInternalLettersErrorGetLetters(this.error);
}
