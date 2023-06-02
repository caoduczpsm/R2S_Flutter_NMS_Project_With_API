// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_api/data/note_data.dart';
import 'package:note_management_system_api/logic/repositories/chart_repository.dart';
import 'package:note_management_system_api/logic/states/chart_state.dart';

class ChartCubit extends Cubit<ChartState> {
  final ChartRepository _repository;

  ChartCubit(this._repository) : super(InitialChartState());

  Future<NoteData> getAllNotes(String email) async {
    emit(LoadingChartState());
    try {
      var result = await _repository.getAllData(email);
      emit(SuccessLoadAllChartState(result));
      return result;
    } catch (e) {
      emit(FailureChartState(e.toString()));
      return NoteData(data: []);
    }
  }
}
