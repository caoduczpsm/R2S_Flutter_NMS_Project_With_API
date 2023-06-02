
import '../../data/note_data.dart';

abstract class NoteState{
  final NoteData? notes;

  NoteState({this.notes});
}

class InitialNoteState extends NoteState{}

class LoadingNoteState extends NoteState{}

class FailureNoteState extends NoteState{
  final String errorMessage;
  FailureNoteState(this.errorMessage);
}

class SuccessLoadAllNoteState extends NoteState{
  SuccessLoadAllNoteState(NoteData notes) : super(notes: notes);
}

class SuccessSubmitNoteState extends NoteState{
  SuccessSubmitNoteState(NoteData notes) : super(notes: notes);
}