
import '../../data/note_data.dart';

abstract class CategoryState{}

class InitialCategoryState extends CategoryState{}

class LoadingCategoryState extends CategoryState{}

class FailureCategoryState extends CategoryState{
  final String errorMessage;
  FailureCategoryState(this.errorMessage);
}

class SuccessLoadAllCategoryState extends CategoryState{
  final NoteData data;
  SuccessLoadAllCategoryState(this.data);
}

class SuccessSubmitCategoryState extends CategoryState{
  final NoteData noteData;
  SuccessSubmitCategoryState(this.noteData);
}