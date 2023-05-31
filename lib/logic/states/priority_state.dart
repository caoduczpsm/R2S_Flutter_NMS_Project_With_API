
import '../../data/note_data.dart';

abstract class PriorityState{
  late final NoteData data;
}

class InitialPriorityState extends PriorityState{}

class LoadingPriorityState extends PriorityState{}

class FailurePriorityState extends PriorityState{
  final String errorMessage;
  FailurePriorityState(this.errorMessage);
}

class SuccessLoadAllPriorityState extends PriorityState{
  SuccessLoadAllPriorityState(data);
}

class SuccessSubmitPriorityState extends PriorityState{
  SuccessSubmitPriorityState(noteData);
}