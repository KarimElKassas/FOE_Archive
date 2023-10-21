abstract class IncomingLettersStates{}

class IncomingLettersInitial extends IncomingLettersStates{}
class IncomingLettersChangeSelectedLetter extends IncomingLettersStates{}
class IncomingLettersChangeInternal extends IncomingLettersStates{}
class IncomingLettersChangeSortMethod extends IncomingLettersStates{}
class IncomingLettersSearchLetters extends IncomingLettersStates{}
class IncomingLettersLoadingLetters extends IncomingLettersStates{}
class IncomingLettersSuccessfulGetLetters extends IncomingLettersStates{}
class IncomingLettersErrorGetLetters extends IncomingLettersStates{
  final String error;

  IncomingLettersErrorGetLetters(this.error);
}
