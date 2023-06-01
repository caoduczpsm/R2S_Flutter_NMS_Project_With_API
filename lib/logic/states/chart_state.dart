import '../../data/note_data.dart';

abstract class ChartState{
  late final NoteData data;
}

class InitialChartState extends ChartState{}

class LoadingChartState extends ChartState{}

class FailureChartState extends ChartState{
  final String errorMessage;
  FailureChartState(this.errorMessage);
}

class SuccessLoadAllChartState extends ChartState{
  SuccessLoadAllChartState(data);
}

class SuccessSubmitChartState extends ChartState{
  SuccessSubmitChartState(data);
}