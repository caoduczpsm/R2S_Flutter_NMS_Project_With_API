
import '../../data/note_data.dart';

abstract class StatusState{}

class InitialStatusState extends StatusState{}

class LoadingStatusState extends StatusState{}

class FailureStatusState extends StatusState{
  final String errorMessage;
  FailureStatusState(this.errorMessage);
}

class SuccessLoadAllStatusState extends StatusState{
  final NoteData data;
  SuccessLoadAllStatusState(this.data);
}

class SuccessSubmitStatusState extends StatusState{
  final NoteData noteData;
  SuccessSubmitStatusState(this.noteData);
}