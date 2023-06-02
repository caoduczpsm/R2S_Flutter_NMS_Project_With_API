
import '../../data/note_data.dart';

abstract class StatusState{
  late final NoteData data;
}

class InitialStatusState extends StatusState{}

class LoadingStatusState extends StatusState{}

class FailureStatusState extends StatusState{
  final String errorMessage;
  FailureStatusState(this.errorMessage);
}

class SuccessLoadAllStatusState extends StatusState{
  SuccessLoadAllStatusState(data) : super() {
    this.data = data;
  }
}

class SuccessSubmitStatusState extends StatusState{
  SuccessSubmitStatusState(data) : super() {
    this.data = data;
  }
}