
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_api/data/note_data.dart';
import 'package:note_management_system_api/logic/repositories/category_repository.dart';
import 'package:note_management_system_api/logic/states/category_state.dart';

class CategoryCubit extends Cubit<CategoryState>{
  final CategoryRepository _repository;

  CategoryCubit(this._repository) : super(InitialCategoryState());

  Future<NoteData?> getAllData(String email) async {
    emit(LoadingCategoryState());
    try {
      var result = await _repository.getAllData(email);
      emit(SuccessLoadAllCategoryState(result));
      return result;
    } catch (e) {
      emit(FailureCategoryState(e.toString()));
      return null;
    }
  }
}