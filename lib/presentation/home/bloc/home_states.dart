abstract class HomeStates{}
class HomeInitialState extends HomeStates{}
class HomeChangeSelectedBox extends HomeStates{}
class HomeChangeSelectedLetter extends HomeStates{}
class HomeChangeSortMethod extends HomeStates{}
class HomeChangeFilterDirection extends HomeStates{}
class HomeChangeFilterTwoDates extends HomeStates{}
class HomeChangeFilterByYear extends HomeStates{}
class HomeChangeFilterByMonth extends HomeStates{}
class HomeChangeFilterByDay extends HomeStates{}
class HomeChangeFilterByTag extends HomeStates{}
class HomeAddOrRemoveFilteredDirectionState extends HomeStates{}
class HomePrepareFilteredList extends HomeStates{}
class HomeSearchLetters extends HomeStates{}
class HomeLogOut extends HomeStates{}
class HomeLoadingLetters extends HomeStates{}
class HomeGetLettersSuccess extends HomeStates{}
class HomeGetLettersError extends HomeStates{
  final String error;

  HomeGetLettersError(this.error);
}
class HomeLoadingDirections extends HomeStates{}
class HomeGetDirectionsSuccess extends HomeStates{}
class HomeGetDirectionsError extends HomeStates{
  final String error;

  HomeGetDirectionsError(this.error);
}