abstract class SecretaryHomeStates{}
class SecretaryHomeInitialState extends SecretaryHomeStates{}
class SecretaryHomeChangeSelectedBox extends SecretaryHomeStates{}
class SecretaryHomeChangeSelectedLetter extends SecretaryHomeStates{}
class SecretaryHomeChangeSortMethod extends SecretaryHomeStates{}
class SecretaryHomeChangeFilterDirection extends SecretaryHomeStates{}
class SecretaryHomeChangeFilterTwoDates extends SecretaryHomeStates{}
class SecretaryHomeChangeFilterByYear extends SecretaryHomeStates{}
class SecretaryHomeChangeFilterByMonth extends SecretaryHomeStates{}
class SecretaryHomeChangeFilterByDay extends SecretaryHomeStates{}
class SecretaryHomeChangeFilterByTag extends SecretaryHomeStates{}
class SecretaryHomeAddOrRemoveFilteredDirectionState extends SecretaryHomeStates{}
class SecretaryHomePrepareFilteredList extends SecretaryHomeStates{}
class SecretaryHomeSearchLetters extends SecretaryHomeStates{}
class SecretaryHomeLogOut extends SecretaryHomeStates{}
class SecretaryHomeLoadingLetters extends SecretaryHomeStates{}
class SecretaryHomeGetLettersSuccess extends SecretaryHomeStates{}
class SecretaryHomeGetLettersError extends SecretaryHomeStates{
  final String error;

  SecretaryHomeGetLettersError(this.error);
}
class SecretaryHomeLoadingDirections extends SecretaryHomeStates{}
class SecretaryHomeGetDirectionsSuccess extends SecretaryHomeStates{}
class SecretaryHomeGetDirectionsError extends SecretaryHomeStates{
  final String error;

  SecretaryHomeGetDirectionsError(this.error);
}