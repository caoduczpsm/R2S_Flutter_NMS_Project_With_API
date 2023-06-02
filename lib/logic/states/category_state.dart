
import '../../data/note_data.dart';

abstract class CategoryState{
  late final NoteData data;
}

class InitialCategoryState extends CategoryState{}

class LoadingCategoryState extends CategoryState{}

class FailureCategoryState extends CategoryState{
  final String errorMessage;
  FailureCategoryState(this.errorMessage);
}

class SuccessLoadAllCategoryState extends CategoryState {
  SuccessLoadAllCategoryState(data) : super() {
    this.data = data;
  }
}

class SuccessSubmitCategoryState extends CategoryState {
  SuccessSubmitCategoryState(data) : super() {
    this.data = data;
  }
}