
import '../../data/note_data.dart';

abstract class PriorityState{}

class InitialPriorityState extends PriorityState{}

class LoadingPriorityState extends PriorityState{}

class FailurePriorityState extends PriorityState{
  final String errorMessage;
  FailurePriorityState(this.errorMessage);
}

class SuccessLoadAllPriorityState extends PriorityState{
  final NoteData data;
  SuccessLoadAllPriorityState(this.data);
}

class SuccessSubmitPriorityState extends PriorityState{
  final NoteData noteData;
  SuccessSubmitPriorityState(this.noteData);
}