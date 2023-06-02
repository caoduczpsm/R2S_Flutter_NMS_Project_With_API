
import '../../data/note_data.dart';

abstract class CategoryState{
  final NoteData? data;

  CategoryState({this.data});
}

class InitialCategoryState extends CategoryState{}

class LoadingCategoryState extends CategoryState{}

class FailureCategoryState extends CategoryState{
  final String errorMessage;
  FailureCategoryState(this.errorMessage);
}

class SuccessLoadAllCategoryState extends CategoryState{
  SuccessLoadAllCategoryState(NoteData data) : super(data: data);
}

class SuccessSubmitCategoryState extends CategoryState{
  SuccessSubmitCategoryState(NoteData data) : super(data: data);
}