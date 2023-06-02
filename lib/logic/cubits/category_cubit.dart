
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
      var result = await _repository.getAllCategory(email);
      emit(SuccessLoadAllCategoryState(result));
      return result;
    } catch (e) {
      emit(FailureCategoryState(e.toString()));
      return null;
    }
  }

  Future<NoteData?> createCategory(String email, String name) async {
    emit(LoadingCategoryState());
    try {
      var result = await _repository.createCategory(email, name);
      emit(SuccessSubmitCategoryState(result));
      return result;
    } catch (e) {
      emit(FailureCategoryState(e.toString()));
      return null;
    }
  }

  Future<NoteData?> updateCategory(String email, String name, String? nName) async {
    emit(LoadingCategoryState());
    try {
      var result = await _repository.updateCategory(email, name, nName);
      emit(SuccessSubmitCategoryState(result));
      return result;
    } catch (e) {
      emit(FailureCategoryState(e.toString()));
      return null;
    }
  }

  Future<NoteData?> deleteCategory(String email, String name) async {
    emit(LoadingCategoryState());
    try {
      var result = await _repository.deleteCategory(email, name);
      emit(SuccessSubmitCategoryState(result));
      return result;
    } catch (e) {
      emit(FailureCategoryState(e.toString()));
      return null;
    }
  }
}