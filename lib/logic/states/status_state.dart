
import '../../data/note_data.dart';

abstract class StatusState{
  final NoteData? data;

  StatusState({this.data});
}

class InitialStatusState extends StatusState{}

class LoadingStatusState extends StatusState{}

class FailureStatusState extends StatusState{
  final String errorMessage;
  FailureStatusState(this.errorMessage);
}

class SuccessLoadAllStatusState extends StatusState{
  SuccessLoadAllStatusState(NoteData data) : super(data: data);
}

class SuccessSubmitStatusState extends StatusState{
  SuccessSubmitStatusState(NoteData data) : super(data: data);
}