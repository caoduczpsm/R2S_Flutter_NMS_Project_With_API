// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/note_data.dart';
import '../repositories/note_repository.dart';
import '../states/note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final NoteRepository _repository;

  NoteCubit(this._repository) : super(InitialNoteState());

  Future<void> getAllNotes(String email) async {
    emit(LoadingNoteState());
    try {
      var result = await _repository.getAllData(email);
      emit(SuccessLoadAllNoteState(result));
    } catch (e) {
      emit(FailureNoteState(e.toString()));
    }
  }

  Future<NoteData?> createNote(String email, String name, String priority,
      String category, String status, String planDate) async {
    emit(LoadingNoteState());
    try {
      var result = await _repository.createNote(
          email, name, priority, category, status, planDate);
      emit(SuccessSubmitNoteState(result));
      return result;
    } catch (e) {
      emit(FailureNoteState(e.toString()));
      return null;
    }
  }

  Future<NoteData?> updateNote(String email, String name, String? nName, String priority,
      String category, String status, String planDate) async {
    emit(LoadingNoteState());
    try {
      var result = await _repository.updateNote(
          email, name, nName, priority, category, status, planDate);
      emit(SuccessSubmitNoteState(result));
      return result;
    } catch (e) {
      emit(FailureNoteState(e.toString()));
      return null;
    }
  }

  Future<NoteData?> deleteNote(String email, String name) async {
    //emit(LoadingNoteState());
    try {
      var result = await _repository.deleteNote(email, name);
      //emit(SuccessSubmitNoteState(result));
      return result;
    } catch (e) {
      emit(FailureNoteState(e.toString()));
      return null;
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
