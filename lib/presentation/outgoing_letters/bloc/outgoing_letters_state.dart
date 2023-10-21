abstract class OutgoingLettersStates{}

class OutgoingLettersInitial extends OutgoingLettersStates{}
class OutgoingLettersChangeSelectedLetter extends OutgoingLettersStates{}
class OutgoingLettersChangeInternal extends OutgoingLettersStates{}
class OutgoingLettersChangeSortMethod extends OutgoingLettersStates{}
class OutgoingLettersSearchLetters extends OutgoingLettersStates{}
class OutgoingLettersLoadingLetters extends OutgoingLettersStates{}
class OutgoingLettersSuccessfulGetLetters extends OutgoingLettersStates{}
class OutgoingLettersErrorGetLetters extends OutgoingLettersStates{
  final String error;

  OutgoingLettersErrorGetLetters(this.error);
}
