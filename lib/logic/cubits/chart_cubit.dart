// ignore: depend_on_referenced_packages
import 'dart:math';
import 'dart:ui';
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

  Map<String, double> toMapData(String email, NoteData noteData) {
    Map<String, double> dataMap = {};
    noteData.data?.forEach((element) {
      dataMap[element[0]] = double.parse(element[1]);
    });
    return dataMap;
  }

  List<Color> randomListColor(NoteData noteData){
    List<Color> randomColors = [];
    for (var i = 0; i < noteData.data!.length; i++){
      randomColors.add(Color.fromARGB(Random().nextInt(256),
          Random().nextInt(256), Random().nextInt(256), Random().nextInt(256)));
    }
    return randomColors;
  }

}
