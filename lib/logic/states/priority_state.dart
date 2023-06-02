
import '../../data/note_data.dart';

abstract class PriorityState{
  final NoteData? data;

  PriorityState({this.data});
}

class InitialPriorityState extends PriorityState{}

class LoadingPriorityState extends PriorityState{}

class FailurePriorityState extends PriorityState{
  final String errorMessage;
  FailurePriorityState(this.errorMessage);
}

class SuccessLoadAllPriorityState extends PriorityState{
  SuccessLoadAllPriorityState(NoteData data) : super(data: data);
}

class SuccessSubmitPriorityState extends PriorityState{
  SuccessSubmitPriorityState(NoteData data) : super(data: data);
}