
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:note_management_system_api/data/note_data.dart';

import '../repositories/status_repository.dart';
import '../states/status_state.dart';

class StatusCubit extends Cubit<StatusState>{
  final StatusRepository _repository;

  StatusCubit(this._repository) : super(InitialStatusState());

  Future<NoteData?> getAllData(String email) async {
    emit(LoadingStatusState());
    try {
      var result = await _repository.getAllStatus(email);
      emit(SuccessLoadAllStatusState(result));
      return result;
    } catch (e) {
      emit(FailureStatusState(e.toString()));
      return null;
    }
  }

  Future<NoteData?> createStatus(String email, String name) async {
    emit(LoadingStatusState());
    try {
      var result = await _repository.createStatus(email, name);
      emit(SuccessSubmitStatusState(result));
      return result;
    } catch (e) {
      emit(FailureStatusState(e.toString()));
      return null;
    }
  }

  Future<NoteData?> updateStatus(String email, String name, String? nName) async {
    emit(LoadingStatusState());
    try {
      var result = await _repository.updateStatus(email, name, nName);
      emit(SuccessSubmitStatusState(result));
      return result;
    } catch (e) {
      emit(FailureStatusState(e.toString()));
      return null;
    }
  }

  Future<NoteData?> deleteStatus(String email, String name) async {
    emit(LoadingStatusState());
    try {
      var result = await _repository.deleteStatus(email, name);
      emit(SuccessSubmitStatusState(result));
      return result;
    } catch (e) {
      emit(FailureStatusState(e.toString()));
      return null;
    }
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }
}