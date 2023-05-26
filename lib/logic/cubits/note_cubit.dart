// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
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
}
