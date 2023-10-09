import 'package:foe_archive/data/models/letter_model.dart';

class LetterDetailsArgs{
  final LetterModel letterModel;
  final bool openedFromReply;

  LetterDetailsArgs(this.letterModel, this.openedFromReply);
}