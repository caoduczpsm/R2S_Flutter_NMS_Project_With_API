
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:note_management_system_api/data/note_data.dart';
import '../repositories/priority_repository.dart';
import '../states/priority_state.dart';

class PriorityCubit extends Cubit<PriorityState>{
  final PriorityRepository _repository;

  PriorityCubit(this._repository) : super(InitialPriorityState());

  Future<NoteData?> getAllData(String email) async {
    emit(LoadingPriorityState());
    try {
      var result = await _repository.getAllPriority(email);
      emit(SuccessLoadAllPriorityState(result));
      return result;
    } catch (e) {
      emit(FailurePriorityState(e.toString()));
      return null;
    }
  }

  Future<NoteData?> createPriority(String email, String name) async {
    emit(LoadingPriorityState());
    try {
      var result = await _repository.createPriority(email, name);
      emit(SuccessSubmitPriorityState(result));
      return result;
    } catch (e) {
      emit(FailurePriorityState(e.toString()));
      return null;
    }
  }

  Future<NoteData?> updatePriority(String email, String name, String? nName) async {
    emit(LoadingPriorityState());
    try {
      var result = await _repository.updatePriority(email, name, nName);
      emit(SuccessSubmitPriorityState(result));
      return result;
    } catch (e) {
      emit(FailurePriorityState(e.toString()));
      return null;
    }
  }

  Future<NoteData?> deletePriority(String email, String name) async {
    emit(LoadingPriorityState());
    try {
      var result = await _repository.deletePriority(email, name);
      emit(SuccessSubmitPriorityState(result));
      return result;
    } catch (e) {
      emit(FailurePriorityState(e.toString()));
      return null;
    }
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }
}