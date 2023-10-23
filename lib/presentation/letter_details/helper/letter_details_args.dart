import 'package:file_picker/file_picker.dart';
import 'package:foe_archive/data/models/letter_model.dart';

import '../../../data/models/selected_department_model.dart';

class LetterDetailsArgs{
  final LetterModel letterModel;
  final int letterType;
  final bool openedFromReply;

  LetterDetailsArgs(this.letterModel,this.letterType, this.openedFromReply);
}
class UpdateLetterArgs{
  final LetterModel letterModel;
  final List<PlatformFile> letterFiles;
  final List<SelectedDepartmentModel?> selectedActionList;
  final List<SelectedDepartmentModel?> selectedKnowList;

  UpdateLetterArgs(this.letterModel, this.letterFiles,this.selectedActionList,this.selectedKnowList);
}