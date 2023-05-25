
import '../../data/note_data.dart';

abstract class NoteState{}

class InitialNoteState extends NoteState{}

class LoadingNoteState extends NoteState{}

class FailureNoteState extends NoteState{
  final String errorMessage;
  FailureNoteState(this.errorMessage);
}

class SuccessLoadAllNoteState extends NoteState{
  final NoteData notes;
  SuccessLoadAllNoteState(this.notes);
}

class SuccessSubmitNoteState extends NoteState{
  final NoteData noteData;
  SuccessSubmitNoteState(this.noteData);
}