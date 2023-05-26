
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_api/data/note_data.dart';
import 'package:note_management_system_api/logic/repositories/category_repository.dart';
import 'package:note_management_system_api/logic/repositories/status_repository.dart';
import 'package:note_management_system_api/logic/states/status_state.dart';

class StatusCubit extends Cubit<StatusState>{
  final StatusRepository _repository;

  StatusCubit(this._repository) : super(InitialStatusState());

  Future<NoteData?> getAllData(String email) async {
    emit(LoadingStatusState());
    try {
      var result = await _repository.getAllData(email);
      emit(SuccessLoadAllStatusState(result));
      return result;
    } catch (e) {
      emit(FailureStatusState(e.toString()));
      return null;
    }
  }
}